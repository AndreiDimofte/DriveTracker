//
//  LocationManager.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 18.04.2025.
//

import Foundation
import CoreLocation
import Combine

/// Manages all location updates, heading, speed, distance, and timing for an active drive.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - Private Properties
    
    private let manager = CLLocationManager() // Core Location manager instance
    private let geocoder = CLGeocoder() // For reverse geocoding coordinates
    private var lastLocation: CLLocation? // Last known location (for distance)
    private var timer: Timer? // Timer to update elapsed time
    private var startTime: Date? // Timestamp of when the drive started
    
    // MARK: - Published Properties
    
    @Published var userLocation: CLLocation? // Current user location
    @Published var heading: CLLocationDirection = 0.0 // Current compass heading
    @Published var totalDistance: CLLocationDistance = 0.0 // Distance traveled in meters
    @Published var elapsedTime: TimeInterval = 0.0 // Time since start of drive
    @Published var routeCoordinates: [CLLocationCoordinate2D] = [] // Full route
    @Published var averageSpeed: Double = 0.0 // Average speed in km/h
    @Published var startAddress: String = "" // Reverse-geocoded start address
    @Published var endAddress: String = "" // Reverse-geocoded end address
    
    // MARK: - Computed Properties
    
    /// Returns the current speed in km/h
    var speedInKmh: Double {
        guard let speed = userLocation?.speed, speed >= 0 else { return 0 }
        return speed * 3.6;
    }
    
    /// Formats totalDistance as a readable string (meters or kilometers)
    var formattedDistance: String {
        totalDistance < 1000
        ? "\(Int(totalDistance)) m"
        : String(format: "%.2f km", totalDistance / 1000)
    }
    
    /// Formats elapsedTime as MM:SS or HH:MM:SS
    var formattedElapsedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) / 60) % 60
        let seconds = Int(elapsedTime) % 60
        
        return hours > 0
        ? String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        : String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        userLocation = newLocation
        
        // Distance tracking
        if let lastCoord = routeCoordinates.last {
            let lastLoc = CLLocation(latitude: lastCoord.latitude, longitude: lastCoord.longitude)
            let distanceDelta = newLocation.distance(from: lastLoc)
            totalDistance += distanceDelta
        }
        
        routeCoordinates.append(newLocation.coordinate)
        lastLocation = newLocation
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
    }
    
    // MARK: - Geocoding
    
    /// Converts a CLLocationCoordinate2D to a human-readable address
    func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            if let placemark = placemarks?.first {
                let address = [
                    placemark.name,
                    placemark.locality,
                ]
                    .compactMap { $0 }
                    .joined(separator: ", ")
                
                completion(address)
            } else {
                completion("Unknown location")
            }
        }
    }
    
    /// Resolves and stores the start and end addresses from the route
    func resolveDriveAddresses(completion: @escaping (_ start: String, _ end: String) -> Void) {
        guard let startCoord = routeCoordinates.first else {
            completion("Unknown", "Unknown")
            return
        }
        
        let endCoord = routeCoordinates.last
        
        guard let safeEndCoord = endCoord else {
            completion("Unknown", "Unknown")
            return
        }
        
        reverseGeocode(coordinate: startCoord) { startAddress in
            self.reverseGeocode(coordinate: safeEndCoord) { endAddress in
                self.startAddress = startAddress
                self.endAddress = endAddress
                completion(startAddress, endAddress)
            }
        }
    }
    
    // MARK: - Drive Lifecycle
    
    /// Starts tracking a new drive
    func startDrive() {
        startTime = Date()
        elapsedTime = 0
        totalDistance = 0
        lastLocation = nil
        routeCoordinates.removeAll()
        averageSpeed = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let start = self.startTime {
                self.elapsedTime = Date().timeIntervalSince(start)
                self.averageSpeed = self.elapsedTime > 0
                ? self.totalDistance / self.elapsedTime * 3.6
                : 0
            }
        }
    }
    
    /// Stops the current drive and ends location tracking
    func stopDrive() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        timer?.invalidate()
        timer = nil
    }
    
}

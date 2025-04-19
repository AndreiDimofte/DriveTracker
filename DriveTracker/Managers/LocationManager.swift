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
    
    private let manager = CLLocationManager()
    private var lastLocation: CLLocation?
    private var timer: Timer?
    private var startTime: Date?
    
    // MARK: - Published Properties
    
    @Published var userLocation: CLLocation?
    @Published var heading: CLLocationDirection = 0.0
    @Published var totalDistance: CLLocationDistance = 0.0
    @Published var elapsedTime: TimeInterval = 0.0
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var maxSpeed: Double = 0.0
    
    // MARK: - Computed Properties
    
    var speedInKmh: Double {
        guard let speed = userLocation?.speed, speed >= 0 else { return 0 }
        return speed * 3.6;
    }
    
    var formattedDistance: String {
        totalDistance < 1000
        ? "\(Int(totalDistance)) m"
        : String(format: "%.2f km", totalDistance / 1000)
    }
    
    var formattedElapsedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
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
        
        // Update max speed if valid
        if newLocation.speed >= 0 {
            maxSpeed = max(maxSpeed, newLocation.speed * 3.6)
        }
        
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
    
    // MARK: - Drive Lifecycle
    
    /// Starts a new drive session, resetting distance and elapsed time.
    func startDrive() {
        startTime = Date()
        elapsedTime = 0
        totalDistance = 0
        lastLocation = nil
        routeCoordinates.removeAll()
        maxSpeed = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let start = self.startTime {
                self.elapsedTime = Date().timeIntervalSince(start)
            }
        }
    }
    
    /// Stops the current drive session and invalidates the timer.
    func stopDrive() {
        timer?.invalidate()
        timer = nil
    }
    
}

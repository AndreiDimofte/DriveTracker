//
//  DriveView.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 18.04.2025.
//

import SwiftUI
import MapKit
import CoreLocation

/// Main view for an active drive. Displays a live tracking map and driving statistics.
struct DriveView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isDriveFinished = false
    @State private var driveSummary: DriveSummary? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                DriveMapView(locationManager: locationManager)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    // Bottom stat  bar
                    HStack {
                        Text(locationManager.formattedDistance)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        Text(String(format: "%.0f km/h", locationManager.speedInKmh))
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text(locationManager.formattedElapsedTime)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.trailing, 20.0)
                    }
                    .frame(height: 60)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(16)
                    .padding()
                    
                    // Stop drive button
                    Button(action: stopDrive) {
                        Text("Stop Drive")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 10)
                }
            }
            .onAppear {
                locationManager.startDrive()
            }
            .navigationDestination(isPresented: $isDriveFinished) {
                if let summary = driveSummary {
                    FinishView(summary: summary)
                }
            }
        }
    }
    
    /// Called when the user presses the Stop Drive button. Collects summary and triggers navigation.
    private func stopDrive() {
        locationManager.stopDrive()
        
        driveSummary = DriveSummary(
            coordinates: locationManager.routeCoordinates,
            totalDistance: locationManager.totalDistance,
            maxSpeed: locationManager.maxSpeed,
            duration: locationManager.elapsedTime
        )
        
        isDriveFinished = true
    }
}


#Preview {
    DriveView()
}

//
//  FinishView.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 18.04.2025.
//

import SwiftUI
import CoreLocation
import MapKit

/// A view that displays a summary of the completed drive,
/// including a route map, statistics, and the option to name and save the drive.
struct FinishView: View {
    let summary: DriveSummary // The drive data to display
    
    @State private var driveName: String = "" // User-entered name for the drive
    @State private var isSaved: Bool = false // Flag to show confirmation message
    
    @Environment(\.dismiss) var dismiss // Environment property to navigate back
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Miniature route map
            Map {
                MapPolyline(coordinates: summary.coordinates.map { $0.coordinate })
                    .stroke(.blue, lineWidth: 4)
            }
            .frame(height: 200)
            .cornerRadius(12)
            .padding()
            
            // Drive statistics
            VStack(alignment: .leading, spacing: 12) {
                Text("From: \(summary.startAddress)")
                Text("To: \(summary.endAddress)")
                Text("Distance: \(formattedDistance(summary.totalDistance))")
                Text("Average Speed: \(String(format: "%.0f", summary.averageSpeed)) km/h")
                Text("Total Time: \(formattedTime(summary.duration))")
            }
            .font(.headline)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Name input field
            TextField("Enter a name for your drive", text: $driveName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Save button
            Button(action: saveDrive) {
                Text("Save Drive")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(driveName.isEmpty ? Color.gray : Color.green)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .disabled(driveName.isEmpty)
            .padding(.bottom, 10)
            
            // Save confirmation message
            if isSaved {
                Text("Drive saved successfully!")
                    .foregroundStyle(Color.green)
                    .font(.headline)
            }
            
            Spacer()
        }
        .navigationTitle("Drive Summary")
    }
    
    /// Formats the distance in meters or kilometers.
    private func formattedDistance(_ distance: Double) -> String {
        if distance >= 1000 {
            return String(format: "%.2f km", distance / 1000)
        } else {
            return String(format: "%.0f m", distance)
        }
    }
    
    /// Formats the duation as MM:SS or HH:MM:SS
    private func formattedTime(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) / 60) % 60
        let seconds = Int(duration) % 60
        
        return hours > 0
        ? String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        : String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// Saves the current drive to the manager and navigates back after a short delay.
    private func saveDrive() {
        DrivesManager.shared.saveDrive(name: driveName, summary: summary)
        isSaved = true
        
        // Navigate back after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            dismiss()
        }
    }
}

#Preview {
    FinishView(summary: DriveSummary(
        coordinates: [
            CodableCoordinate(from: CLLocationCoordinate2D(latitude: 46.770439, longitude: 23.591423)),
            CodableCoordinate(from: CLLocationCoordinate2D(latitude: 46.771439, longitude: 23.592423))
        ],
        totalDistance: 1234.5,
        averageSpeed: 80.0,
        duration: 145.0,
        startAddress: "Jiului 24",
        endAddress: "Santioana"
    ))
}

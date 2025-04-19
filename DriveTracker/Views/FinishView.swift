//
//  FinishView.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 18.04.2025.
//

import SwiftUI
import CoreLocation
import MapKit

struct FinishView: View {
    let summary: DriveSummary
    
    var body: some View {
        VStack(spacing: 20) {
            // Mini map
            Map {
                MapPolyline(coordinates: summary.coordinates)
                    .stroke(.blue, lineWidth: 4)
            }
            .frame(height: 200)
            .cornerRadius(12)
            .padding()
            
            // Stats
            VStack(alignment: .leading, spacing: 12) {
                Text("Distance: \(formattedDistance(summary.totalDistance))")
                Text("Max Speed: \(String(format: "%.0f", summary.maxSpeed)) km/h")
                Text("Total Time: \(formattedTime(summary.duration))")
            }
            .font(.headline)
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("Drive Summary")
    }
    
    private func formattedDistance(_ distance: Double) -> String {
        if distance >= 1000 {
            return String(format: "%.2f km", distance / 1000)
        } else {
            return String(format: "%.0f m", distance)
        }
    }
    
    private func formattedTime(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    FinishView(summary: DriveSummary(
        coordinates: [
            CLLocationCoordinate2D(latitude: 46.770439, longitude: 23.591423),
            CLLocationCoordinate2D(latitude: 46.771439, longitude: 23.592423)
        ],
        totalDistance: 1234.5,
        maxSpeed: 80.0,
        duration: 145.0
    ))
}

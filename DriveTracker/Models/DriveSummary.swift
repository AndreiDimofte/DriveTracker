//
//  DriveSummary.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 19.04.2025.
//

import CoreLocation

/// Represents the result of a completed drive.
struct DriveSummary {
    let coordinates: [CLLocationCoordinate2D]
    let totalDistance: Double
    let maxSpeed: Double
    let duration: TimeInterval
}

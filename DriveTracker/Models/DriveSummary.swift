//
//  DriveSummary.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 19.04.2025.
//

import CoreLocation

struct DriveSummary {
    let coordinates: [CLLocationCoordinate2D]
    let totalDistance: Double
    let maxSpeed: Double
    let duration: TimeInterval
}

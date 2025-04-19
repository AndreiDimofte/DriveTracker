//
//  DriveSummary.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 19.04.2025.
//

import CoreLocation

/// Represents the result of a completed drive.
/// Stores all relevant metrics and route information for summary display and saving
struct DriveSummary: Codable {
    let coordinates: [CodableCoordinate] // Array of all route coordinates
    let totalDistance: Double // Total distance driven in meters
    let averageSpeed: Double // Average speed in km/h
    let duration: TimeInterval // Duration of the drive in seconds
    let startAddress: String // Human-readable start location
    let endAddress: String // Human-readable end location
}

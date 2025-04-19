//
//  SavedDrive.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 19.04.2025.
//

import Foundation

/// A saved drive with metadata and user-defined name.
struct SavedDrive: Identifiable, Codable {
    let id: UUID
    let name: String
    let summary: DriveSummary
    let date: Date
}

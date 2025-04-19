//
//  DrivesManager.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 19.04.2025.
//

import Foundation

/// Manages saving and loading of saved drives using local storage (JSON + FileManager).
class DrivesManager: ObservableObject {
    static let shared = DrivesManager()
    
    @Published private(set) var savedDrives: [SavedDrive] = []
    private let filename = "drives.json"
    
    /// Returns the file URL for the saved data.
    private var fileURL: URL {
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return folder.appendingPathComponent(filename)
    }
    
    private init() {
        loadDrives()
    }
    
    /// Adds a new drive to the list and persists it to disk.
    func saveDrive(name: String, summary: DriveSummary) {
        let newDrive = SavedDrive(id: UUID(), name: name, summary: summary, date: Date())
        savedDrives.append(newDrive)
        persist()
    }
    
    func deleteDrive(at offsets: IndexSet) {
        savedDrives.remove(atOffsets: offsets)
        persist()
    }
    
    /// Saves the current list of drives to disk.
    private func persist() {
        do {
            let data = try JSONEncoder().encode(savedDrives)
            try data.write(to: self.fileURL)
        } catch {
            print("Failed to save drives: \(error)")
        }
    }
    
    /// Loads the saved drives from disk.
    private func loadDrives() {
        do {
            let data = try Data(contentsOf: self.fileURL)
            savedDrives = try JSONDecoder().decode([SavedDrive].self, from: data)
        } catch {
            print("No saved drives found or failed to load: \(error)")
        }
    }
}

//
//  ProfileManager.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 22.04.2025.
//

import Foundation

class ProfileManager: ObservableObject {
    static let shared = ProfileManager()
    
    @Published var profile: Profile?
    
    private let fileName = "user_profile.json"
    
    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }
    
    private init() {
        loadProfile()
    }
    
    func saveProfile(_ profile: Profile) {
        self.profile = profile
        do {
            let data = try JSONEncoder().encode(profile)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save profile: \(error)")
        }
    }
    
    private func loadProfile() {
        do {
            let data = try Data(contentsOf: fileURL)
            self.profile = try JSONDecoder().decode(Profile.self, from: data)
        } catch {
            print("No existing profile found.")
        }
    }
}

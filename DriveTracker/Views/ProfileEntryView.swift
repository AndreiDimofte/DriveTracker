//
//  ProfileEntryView.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 22.04.2025.
//

import SwiftUI

struct ProfileEntryView: View {
    @State private var username = ""
    @State private var car = ""
    var onSave: () -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Your info")) {
                TextField("Username", text: $username)
                TextField("Car", text: $car)
            }
            
            Button("Save") {
                let profile = Profile(username: username, car: car)
                ProfileManager.shared.saveProfile(profile)
                onSave()
            }
            .disabled(username.isEmpty || car.isEmpty)
        }
        .navigationTitle("Create Profile")
    }
}

//
//  StartView.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 19.04.2025.
//

import SwiftUI

/// Welcome screen shown at app launch.
/// Allows the user to start a new drive or view their saved drive history.
struct StartView: View {
    @State private var showProfileEntry = false
    @State private var showProfileOverview = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                // App welcome title
                Text("Welcome to Drive Tracker!")
                    .font(.title)
                    .padding()
                
                // Button: Start a new drive
                NavigationLink(destination: DriveView()) {
                    Text("Start Drive")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                // Button: View previous drives
                NavigationLink(destination: HistoryView()) {
                    Text("Drive History")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                // Profile button
                Button(action: {
                    if ProfileManager.shared.profile == nil {
                        showProfileEntry = true
                    } else {
                        showProfileOverview = true
                    }
                }) {
                    Text("Profile")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationDestination(isPresented: $showProfileEntry) {
                ProfileEntryView(onSave: {
                    showProfileEntry = false
                    showProfileOverview = true
                })
            }
            .navigationDestination(isPresented: $showProfileOverview) {
                ProfileOverviewView()
            }
        }
    }
}

#Preview {
    StartView()
}

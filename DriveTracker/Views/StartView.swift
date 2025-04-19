//
//  StartView.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 19.04.2025.
//

import SwiftUI

/// Welcome screen shown at app launch. Allows the user to start a new drive.
struct StartView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                Text("Welcome to Drive Tracker!")
                    .font(.title)
                    .padding()
                
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
                
                Spacer()
            }
        }
    }
}

#Preview {
    StartView()
}

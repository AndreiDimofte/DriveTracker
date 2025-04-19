//
//  StartView.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 19.04.2025.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Drive Tracker!")
                    .font(.title)
                    .padding()
                
                NavigationLink(destination: DriveView()) {
                    Text("Start Drive")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
            }
        }
    }
}

#Preview {
    StartView()
}

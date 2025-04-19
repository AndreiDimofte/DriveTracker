//
//  HistoryView.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 19.04.2025.
//

import SwiftUI

/// Displays a list of previously saved drives.
struct HistoryView: View {
    @ObservedObject var manager = DrivesManager.shared
    
    var body: some View {
        List(manager.savedDrives.sorted(by: { $0.date > $1.date })) { drive in
            NavigationLink(destination: FinishView(summary: drive.summary)) {
                VStack(alignment: .leading) {
                    Text(drive.name)
                        .font(.headline)
                    Text(formattedDate(drive.date))
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                }
            }
        }
        .navigationTitle("Drive History")
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView()
}

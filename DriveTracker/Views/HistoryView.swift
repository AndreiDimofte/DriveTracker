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
        List {
            ForEach(Array(manager.savedDrives.sorted(by: { $0.date > $1.date }))) { drive in
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
            .onDelete { offsets in
                let sortedDrives = manager.savedDrives.sorted(by: { $0.date > $1.date })
                for offset in offsets {
                    let driveToDelete = sortedDrives[offset]
                    if let originalIndex = manager.savedDrives.firstIndex(where: { $0.id == driveToDelete.id }) {
                        manager.deleteDrive(at: IndexSet(integer: originalIndex))
                    }
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

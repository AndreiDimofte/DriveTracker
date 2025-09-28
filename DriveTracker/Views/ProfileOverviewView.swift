import SwiftUI

struct ProfileOverviewView: View {
    @ObservedObject var manager = ProfileManager.shared
    @State private var isEditingCar = false
    @State private var newCarName = ""
    
    var body: some View {
        VStack(spacing: 20) {
            if let profile = manager.profile {
                Text("Username: \(profile.username)")
                    .font(.title2)
                
                if isEditingCar {
                    TextField("Enter new car name", text: $newCarName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button("Save") {
                        var updatedProfile = profile
                        updatedProfile.car = newCarName
                        manager.saveProfile(updatedProfile)
                        isEditingCar = false
                    }
                    .disabled(newCarName.isEmpty)
                } else {
                    Text("Car: \(profile.car)")
                        .font(.title2)
                    
                    Button("Edit Car") {
                        newCarName = profile.car
                        isEditingCar = true
                    }
                }
            } else {
                Text("No profile available")
                    .font(.title2)
            }
        }
        .padding()
        .navigationTitle("Your Profile")
    }
}

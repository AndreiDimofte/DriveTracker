//
//  DriveView.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 18.04.2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct DriveView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isDriveFinished = false
    @State private var driveSummary: DriveSummary? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                DriveMapUIKitView(locationManager: locationManager)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    // Bottom bar
                    HStack {
                        Text(locationManager.formattedDistance)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        Text(String(format: "%.0f km/h", locationManager.speedInKmh))
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Text(locationManager.formattedElapsedTime)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.trailing, 20.0)
                    }
                    .frame(height: 60)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(16)
                    .padding()
                    
                    // Stop Drive button
                    Button(action: {
                        locationManager.stopDrive()
                        
                        driveSummary = DriveSummary(
                            coordinates: locationManager.routeCoordinates,
                            totalDistance: locationManager.totalDistance,
                            maxSpeed: locationManager.maxSpeed,
                            duration: locationManager.elapsedTime
                        )
                        
                        isDriveFinished = true
                    }) {
                        Text("Stop Drive")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 10)
                }
            }
            .onAppear {
                locationManager.startDrive()
            }
            .navigationDestination(isPresented: $isDriveFinished) {
                if let summary = driveSummary {
                    FinishView(summary: summary)
                }
            }
        }
    }
    
}

struct DriveMapUIKitView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let userLocation = mapView.userLocation.location {
                let camera = MKMapCamera(
                    lookingAtCenter: userLocation.coordinate,
                    fromDistance: 10,
                    pitch: 60,
                    heading: userLocation.course
                )
                mapView.setCamera(camera, animated: false)
            }
            
            mapView.setUserTrackingMode(.followWithHeading, animated: true)
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        guard locationManager.routeCoordinates.count > 1 else { return }
        
        mapView.overlays.forEach { mapView.removeOverlay($0) }
        
        let polyline = MKPolyline(coordinates: locationManager.routeCoordinates, count: locationManager.routeCoordinates.count)
        mapView.addOverlay(polyline)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: DriveMapUIKitView
        
        init(parent: DriveMapUIKitView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.systemBlue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}


#Preview {
    DriveView()
}

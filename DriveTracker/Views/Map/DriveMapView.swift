//
//  DriveMapView.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 19.04.2025.
//

import SwiftUI
import MapKit

/// A UIKit-based MapView wrapped for SwiftUI, used for live route tracking.
struct DriveMapView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    @Binding var isFollowingUser: Bool // Binding to control camera follow state
    @Binding var recenterTrigger: Bool // Toggled when user taps recenter
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        
        // Initial follow mode
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
            isFollowingUser = true
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        guard locationManager.routeCoordinates.count > 1 else { return }
        
        mapView.removeOverlays(mapView.overlays)
        
        let polyline = MKPolyline(
            coordinates: locationManager.routeCoordinates,
            count: locationManager.routeCoordinates.count
        )
        mapView.addOverlay(polyline)
        
        // If user tapped the recenter button
        if recenterTrigger {
            mapView.setUserTrackingMode(.followWithHeading, animated: true)
            DispatchQueue.main.async {
                isFollowingUser = true
            }
            DispatchQueue.main.async {
                recenterTrigger = false
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: DriveMapView
        
        init(parent: DriveMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
            DispatchQueue.main.async {
                self.parent.isFollowingUser = (mode == .followWithHeading)
            }
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

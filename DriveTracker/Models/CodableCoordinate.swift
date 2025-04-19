//
//  CodableCoordinate.swift
//  DriveTracker
//
//  Created by Andrei Dimofte on 19.04.2025.
//

import Foundation
import CoreLocation

/// A codable wrapper around CLLocationCoordinate2D.
/// Used because CLLocationCoordinate2D does not conform to Coadable by default.
struct CodableCoordinate: Codable {
    let latitude: Double // Latitude value of the coordinate
    let longitude: Double // Longitude value of the coordinate
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(from coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}

//
//  LocationManager.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-03-31.
//

import Foundation
import MapKit
import CoreLocation
import Combine


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    private let LocationManager = CLLocationManager()
    
    @Published var UserLocation: CLLocationCoordinate2D?
    
    
    override init() {
        super.init()
        LocationManager.delegate = self
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else {return}
        DispatchQueue.main.async {
            self.UserLocation = latestLocation.coordinate
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location Acess denied")
            manager.stopUpdatingLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            
        default:
            break


        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        manager.stopUpdatingLocation()
    }
    
    
}

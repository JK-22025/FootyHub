//
//  GeoView.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-03-31.
//

import SwiftUI
import MapKit
struct GeoView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var camera: MapCameraPosition = .automatic
    @State private var zoomLevel: Double = 2000
    @State private var searchText: String = ""
    @State private var destination: CLLocationCoordinate2D?
    @State private var route: MKRoute?
    @State private var isSearching: Bool = false
    @State private var errorMessage: String?
    @State private var didAutoCenter: Bool = false
    
    let Anfield = CLLocationCoordinate2D(latitude: 53.4308, longitude: -2.9680)
    let CampNou = CLLocationCoordinate2D(latitude: 41.3809, longitude: -2.1228)
    let EmiratesStadium = CLLocationCoordinate2D(latitude: 51.5549, longitude: -0.1084)
    let SanSiro = CLLocationCoordinate2D(latitude: 45.48, longitude: -9.12)
    let Saputo = CLLocationCoordinate2D(latitude: 45.5631, longitude: -73.5527)
    var body: some View {
        ZStack{
            Map(position: $camera){
                Marker("Anfield", coordinate: Anfield)
                    .tint(.red)
                Marker("CampNou", coordinate: CampNou)
                    .tint(.blue)
                Marker("EmiratesStadium", coordinate: EmiratesStadium)
                    .tint(.red)
                Marker("SanSiro", coordinate: SanSiro)
                    .tint(.red)
                Marker("Saputo", coordinate: Saputo)
                    .tint(.blue)
                if let userLocation = locationManager.UserLocation{
                    Marker("You", coordinate: userLocation)
                        .tint(.blue)
                }
                
                
            }.mapStyle(.standard)
            
            
            
        }
        
        VStack{
            Spacer()
            HStack{
                Spacer()
                VStack(spacing: 10){
                    Button(action: zoomIn) {
                        Image(systemName: "plus.magnifyingglass")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                        
                            
                    }.shadow(radius: 4)
                    
                    Button(action: zoomOut){
                        Image(systemName: "minus.magnifyingglass")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }.shadow(radius: 4)
                }
            }
        }
    }
    
    private func zoomIn(){
        if let userLocation = locationManager.UserLocation{
            withAnimation{
                zoomLevel *= 0.8
                camera = .camera(MapCamera(centerCoordinate: userLocation, distance: zoomLevel))
            }
        }
    }
    
    private func zoomOut(){
        if let userLocation = locationManager.UserLocation{
            withAnimation{
                zoomLevel *= 1.2
                camera = .camera(MapCamera(centerCoordinate: userLocation, distance: zoomLevel))
            }
        }
    }
    
    private func goToUserLocation(){
        if let userLocation = locationManager.UserLocation{
            withAnimation{
                camera = .camera(MapCamera(centerCoordinate: userLocation, distance: zoomLevel))
            }
        }
    }
}

#Preview {
    GeoView()
}


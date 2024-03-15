//
//  ContentView.swift
//  LocationApp
//
//  Created by 승재 on 3/13/24.
//

import SwiftUI
import MapKit
import CoreLocation

extension CLLocationCoordinate2D {
    
    static let destination = CLLocationCoordinate2D(latitude: 36.14555404127778, longitude: 128.39248499391684)
    static let origin = CLLocationCoordinate2D(latitude: 36.14688471903495, longitude: 128.39216131273358)
       
}
extension MKCoordinateRegion {
    static let deigitalAcademy = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 36.14555404127778,
            longitude: 128.39248499391684),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01))
    static let globalAcademy = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 36.14688471903495,
            longitude: 128.39216131273358),
        span: MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5))
}

//            MapPolyline(coordinates: <#T##[CLLocationCoordinate2D]#>)
//                .stroke(.blue, lineWidth: 13)
struct AppleMapVeiw: View {
    
    @Namespace var mapScope
    @State private var position: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedResult: MKMapItem? // Marker 클릭시 담김
    @State private var route: MKRoute?
    
    @State private var locationManager = CLLocationManager()
    
    
    var body: some View {
        Map(position: $position, selection: $selectedResult, scope: mapScope) {
            Annotation(
                "Destination",
                coordinate: .destination,
                anchor: .bottom
            ){
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.background)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.secondary, lineWidth: 5)
                    Image(systemName: "car")
                        .padding(5)
                }
            }
            Annotation(
                "Origin",
                coordinate: .origin,
                anchor: .bottom
            ){
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.background)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.secondary, lineWidth: 5)
                    Image(systemName: "car")
                        .padding(5)
                }
            }
            ForEach(searchResults, id: \.self) { result in
                Marker(item: result)
            }
            .annotationTitles(.hidden)
            UserAnnotation()
            
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 13)
                
            }
            
        }
        .overlay(alignment: .bottomTrailing) {
            VStack{
                MapUserLocationButton(scope: mapScope)
                MapCompass(scope: mapScope)
                    .mapControlVisibility(.visible)
                
            }
            .padding(.trailing, 10)
            .buttonBorderShape(.circle)
        }
        .mapScope(mapScope)
        .mapStyle(.standard(elevation: .realistic))
        .safeAreaInset(edge: .bottom) {
            HStack{
                Spacer()
                VStack(spacing: 0) {
                    if let selectedResult {
                        ItemInfoView(selectedResult: selectedResult, route: route)
                            .frame(height: 128)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding([.top, .horizontal])
                    }
                    
                    MapButtons(position: $position, searchResults: $searchResults, visibleRegion: visibleRegion)
                        .padding(.top)
                    
                }
                
                Spacer()
            }
            .background(.thinMaterial)
        }
        .onChange(of: searchResults){
            position = .automatic
        }
        .onChange(of: selectedResult) {
            getDirections()
        }
        .onAppear(){
            locationManager.requestWhenInUseAuthorization()
        }
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
        .mapControls {
            MapScaleView()
        }
    
    }
    
    func getDirections() {
        route = nil
        guard let selectedResult else { return }
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .origin))
        request.destination = selectedResult
        
        Task {
            let directions = MKDirections(request: request)
            
            
            let response = try? await directions.calculate()
            route = response?.routes.first
            print(("\((route?.expectedTravelTime)!/60) minite"))
        }
    }
}

#Preview {
    AppleMapVeiw()
}

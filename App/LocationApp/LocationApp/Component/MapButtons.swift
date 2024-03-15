//
//  MapButtons.swift
//  LocationApp
//
//  Created by 승재 on 3/14/24.
//

import SwiftUI
import MapKit

struct MapButtons: View {
    
    @Binding var position: MapCameraPosition
    @Binding var searchResults: [MKMapItem]
    
    var visibleRegion: MKCoordinateRegion?
    
    func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? MKCoordinateRegion(
            center: .destination,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
    var body: some View {
        
        HStack{
            Button {
                search(for: "playground")
            } label: {
                Label("PlayGrounds", systemImage: "figure.and.child.holdinghands")
            }
            .buttonStyle(.borderedProminent)
            Button {
                search(for: "Beach")
            } label: {
                Label("Beaches", systemImage: "beach.umbrella")
            }
            .buttonStyle(.borderedProminent)
            Button {
                position = .region(.deigitalAcademy)
            } label: {
                Label("디지털관", systemImage: "person.crop.circle.badge.clock")
            }
            .buttonStyle(.bordered)
            Button {
                position = .region(.globalAcademy)
            } label: {
                Label("글로벌관", systemImage: "figure.outdoor.cycle")
            }
            .buttonStyle(.bordered)
        }
        .labelStyle(.iconOnly)
    }
}

#Preview {
    MapButtons(position: .constant(MapCameraPosition.automatic), searchResults: .constant([]) )
}

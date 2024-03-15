//
//  MapScope.swift
//  LocationApp
//
//  Created by 승재 on 3/14/24.
//

import SwiftUI
import MapKit

struct MapScope: View {
    @Namespace var mapScope
    var body: some View {
        Map(scope: mapScope)
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
    }
}

#Preview {
    MapScope()
}

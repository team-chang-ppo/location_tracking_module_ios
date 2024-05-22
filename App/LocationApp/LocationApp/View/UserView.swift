//
//  UserView.swift
//  LocationApp
//
//  Created by 승재 on 5/23/24.
//

import SwiftUI
import LocationTrackingModule
import MapKit

struct UserView: View {
    var body: some View {
        UserTrackingMap(
            pairToken: "",
            module: LocationTrackingModule.shared,
            origin: CLLocationCoordinate2D(latitude: 36.13782325523192, longitude: 128.42060202080336),
            destination: CLLocationCoordinate2D(latitude: 36.14551321622079, longitude: 128.3923148389114))
    }
}

#Preview {
    UserView()
}

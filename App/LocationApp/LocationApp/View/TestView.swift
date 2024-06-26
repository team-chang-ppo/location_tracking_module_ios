//
//  TestView.swift
//  LocationApp
//
//  Created by 승재 on 5/22/24.
//

import SwiftUI
import MapKit
import LocationTrackingModule

struct TestView: View {
    @State var isTracking: Bool = false
    let deliverModule: LocationTrackingModule
    let userModule: LocationTrackingModule

    init(apiKey: String) {
        self.deliverModule = LocationTrackingModule(
            serverURL: APIConstants.BaseURL,
            key: apiKey,
            configuration: .default
        )
        self.userModule = LocationTrackingModule(
            serverURL: APIConstants.BaseURL,
            configuration: .default
        )
    }

    var body: some View {
        NavigationView {
            VStack {
                LocationTrackingMap(
                    module: deliverModule,
                    origin: CLLocationCoordinate2D(
                        latitude: 36.13847720785065,
                        longitude: 128.396414838321
                    ),
                    destination: CLLocationCoordinate2D(
                        latitude: 36.139053085374016,
                        longitude: 128.396680562473
                    )
                )
                .edgesIgnoringSafeArea(.top)
            }
        }
    }
}

#Preview {
    TestView(apiKey: "eyJhbGciOiJIUzI1NiJ9.eyJNRU1CRVJfSUQiOjQsIkdSQURFX1RZUEUiOiJHUkFERV9DTEFTU0lDIiwiQVBJS0VZX0lEIjo5LCJpYXQiOjE3MTczNDc5NjB9.XCvAzMCM9d2kaBP2h8lxO-aYO7bsjrGhJR5mVwtsY1g")
}

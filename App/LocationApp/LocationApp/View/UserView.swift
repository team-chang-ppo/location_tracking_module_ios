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
    let pairToken: String

    var body: some View {
        UserTrackingMap(
            pairToken: pairToken,
            module: LocationTrackingModule(serverURL: APIConstants.BaseURL, configuration: .default),
            origin: CLLocationCoordinate2D(latitude: 36.13782325523192, longitude: 128.42060202080336),
            destination: CLLocationCoordinate2D(latitude: 36.14551321622079, longitude: 128.3923148389114)
        )
    }
}

#Preview {
    UserView(pairToken: "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjaGFuZy1wcG8tdHJhY2tpbmctbW9kdWxlIiwiU0NPUEUiOlsiV1JJVEVfVFJBQ0tJTkdfQ09PUkRJTkFURSIsIlJFQURfVFJBQ0tJTkdfQ09PUkRJTkFURSJdLCJHUkFERV9UWVBFIjoiR1JBREVfQ0xBU1NJQyIsIkFQSUtFWV9JRCI6OSwiTUVNQkVSX0lEIjo0LCJUUkFDS0lOR19JRCI6ImZiYjIyMTE0LWI1MjMtNDRhOS1iYmMwLWY5MDY2ZTMyOWI0NCIsImlhdCI6MTcxNzUwNzMyOCwiZXhwIjoxNzE3NTA4MjI4fQ.HkxWmz4CJWniGrqkspHmSNXl239r7xmadU3vwfybcfM")
}

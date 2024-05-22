//
//  TestView.swift
//  LocationApp
//
//  Created by 승재 on 5/22/24.
//

import SwiftUI
import MapKit
import LocationTrackingModule


extension LocationTrackingModule{
    static let shared = LocationTrackingModule(
        serverURL: "\(APIConstants.BaseURL)",
        key:"\(APIConstants.apiKey)",
        configuration: .default
    )
}

struct TestView: View {
    @State var isTracking: Bool = false
    var body: some View {
        NavigationView {
            VStack{
                LocationTrackingMap(
                    module: LocationTrackingModule.shared,
                    origin: CLLocationCoordinate2D(latitude: 36.13782325523192, longitude: 128.42060202080336),
                    destination: CLLocationCoordinate2D(latitude: 36.14551321622079, longitude: 128.3923148389114))
                .edgesIgnoringSafeArea(.top)
            }.navigationBarTitle("상세 확인", displayMode: .inline)
            
        }
        
        
    }
    
}

#Preview {
    TestView()
}

//
//  testView.swift
//  LocationApp
//
//  Created by 승재 on 3/14/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State var tracking : Bool = true
    var body: some View {
        Map(){
            UserAnnotation()
        }
        .onAppear(){
            
        }
    }
    
}

#Preview {
    ContentView()
}

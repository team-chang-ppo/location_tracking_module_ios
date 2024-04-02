//
//  LocationAppApp.swift
//  LocationApp
//
//  Created by 승재 on 3/13/24.
//

import SwiftUI
import MapKit
import OHHTTPStubs
import OHHTTPStubsSwift

@main
struct LocationApp: App {
    
    init() {
        setupNetworkStubs()
    }
    func setupNetworkStubs() {
#if DEBUG
        // Connect Mock
        stub(condition: { request in
            let isPostMethod = request.httpMethod == "POST"
            let urlMatches = request.url?.absoluteString == "\(APIConstants.BaseURL)/api/tracking/v1/connect"
            return isPostMethod && urlMatches
        }) { request -> HTTPStubsResponse in
            guard let httpBody = request.ohhttpStubs_httpBody,
                  let _ = try? JSONDecoder().decode(ConnectRequest.self, from: httpBody) else {
                
                return HTTPStubsResponse(error: NSError(domain: "Bad Request", code: 400, userInfo: nil))
            }
            
            let responseJSON = """
            {
                "accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyOTMwNTMiLCJBdXRob3JpdHkiOiJCQVNJQyIsImlhdCI6MTcxMTgxNzEwMywiZXhwIjoxNzExODIwNzAzfQ.TDk8gFv1sLcU4WKQ_1IZA1KmpNfoeDAcFxnOyHX5A88"
            }
            """.data(using: .utf8)!
            
            return HTTPStubsResponse(data: responseJSON, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
        
        // Tracking Mock
        stub(condition: { request in
            let isPostMethod = request.httpMethod == "POST"
            let urlMatches = request.url?.absoluteString == "\(APIConstants.BaseURL)/api/tracking/v1/tracking"
            return isPostMethod && urlMatches
        }) { request -> HTTPStubsResponse in
            
            let responseJSON = "".data(using: .utf8)!
            
            return HTTPStubsResponse(data: responseJSON, statusCode: 200, headers: ["Content-Type": "application/json"])
        }
#endif
        
    }
    
    var body: some Scene {
        WindowGroup {
            //            AppleMapVeiw()
            ContentView(origin: CLLocationCoordinate2D(
                latitude: ConnectRequest.sampleRoute.startPoint.x,
                longitude: ConnectRequest.sampleRoute.startPoint.y),
                        destination: CLLocationCoordinate2D(
                            latitude: ConnectRequest.sampleRoute.endPoint.x,
                            longitude: ConnectRequest.sampleRoute.endPoint.y))
        }
    }
}

//
//  LocationDetailViewModel.swift
//  LocationApp
//
//  Created by 승재 on 4/1/24.
//

import MapKit
import SwiftUI

class LocationDetailViewModel: ObservableObject {
    @Published var route: MKRoute?
    @Published var estimatedTime : Int?
    
    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    
    var networkService = NetworkService()
    
    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        self.origin = origin
        self.destination = destination
    }
    
    func getDirections() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: origin))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        Task {
            do {
                let response = try await directions.calculate()
                if let firstRoute = response.routes.first {
                    DispatchQueue.main.async {
                        self.route = firstRoute
                        self.estimatedTime = Int(firstRoute.expectedTravelTime) / 60
                        print(" \(self.estimatedTime) minute")
                    }
                }
            } catch {
                print("Error calculating directions: \(error)")
            }
        }
    }
    
    func DeliveryStart(){
        networkService.sendConnectRequest(requestRoute: ConnectRequest.sampleRoute) { result in
            switch result {
            case .success(let accessToken):
                print("DeliveryStart: \(accessToken)")
                // 성공 처리 로직
            case .failure(let error):
                print("Error: \(error)")
                // 실패 처리 로직
            }
        }
    }
    
    func DeliveryEnd(){
        networkService.sendDisConnectRequest { result in
            switch result {
            case.success(let message):
                print(message)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func updateRequestLocation(userLocation: CLLocationCoordinate2D?) {
        guard let x = userLocation?.latitude else { return }
        guard let y = userLocation?.longitude else { return }
        
        let request = TrackingRequest(locations: Point(x: x, y: y))
        let networkService = NetworkService()
        
        networkService.sendTrackingRequest(trackingRequest: request) { result in
            switch result {
            case .success(let isSuccess):
                if isSuccess {
                    print("Tracking data successfully sent. \(x),\(y) ")
                } else {
                    print("Tracking data was sent, but not successful.")
                }
            case .failure(let error):
                switch error {
                case .responseError(let statusCode):
                    print("Server responded with an error. Status code: \(statusCode).")
                case .jsonDecodingError(let error):
                    print("JSON decoding error: \(error.localizedDescription).")
                case .invalidResponse:
                    print("Invalid response from the server.")
                case .invalidRequest:
                    print("Invalid request.")
                }
            }
        }
        
    }

}

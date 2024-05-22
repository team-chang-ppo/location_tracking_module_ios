//
//  File.swift
//  
//
//  Created by 승재 on 5/22/24.
//
import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let apiRequest: APIRequest
    
    @Published var permissionDenied = false
    @Published var currentLocation: CLLocationCoordinate2D?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(apiRequest: APIRequest) {
        self.apiRequest = apiRequest
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // 권한 설정 요청
    func requestLocationAccess() {
        
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined, .denied, .restricted:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation() // 권한이 허용되었다면 위치 업데이트 시작
        default:
            break
        }
    }
    
    // 위치 업데이트 중지
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        print("Location updates stopped")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Auth: Allow")
            manager.startUpdatingLocation() // 권한 상태가 변경될 때 위치 업데이트 시작
        case .notDetermined, .denied, .restricted:
            print("Location Auth: Denied")
            permissionDenied = true
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location.coordinate
            sendLocationToServer(location: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to Fetch Location (\(error))")
    }
    
    private func sendLocationToServer(location: CLLocationCoordinate2D) {
        let data: [String: Any] = [
            "latitude": location.latitude,
            "longitude": location.longitude
        ]
        
        apiRequest.sendTrackingData(data: data) { result in
            switch result {
            case .success:
                print("Location data sent successfully")
            case .failure(let error):
                print("Failed to send location data: \(error)")
            }
        }
    }
}

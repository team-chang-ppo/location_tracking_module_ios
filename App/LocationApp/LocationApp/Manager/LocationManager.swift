//
//  LocationManager.swift
//  LocationApp
//
//  Created by 승재 on 3/14/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var permissionDenied = false
    @Published var currentLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.requestLocationAccess()
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
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Auth: Allow")
            manager.startUpdatingLocation() // 권한 상태가 변경될 때 위치 업데이트 시작
        case .notDetermined, .denied, .restricted:
            print("Location Auth: Denied")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location.coordinate
            print(" \(String(describing: currentLocation?.latitude)) , \(String(describing: currentLocation?.longitude))")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to Fetch Location (\(error))")
    }
}

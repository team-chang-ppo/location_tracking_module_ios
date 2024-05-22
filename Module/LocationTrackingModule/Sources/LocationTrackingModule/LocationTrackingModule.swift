// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine
import CoreLocation

public class LocationTrackingModule {
    private let apiRequest: APIRequest
    private var locationManager: LocationManager?
    
    var apiKey: String {
        apiRequest.key
    }
    
    
    /// LocationTrackingModule 생성시 토큰이 발행됩니다.
    /// - Parameters:
    ///   - serverURL: 서버 주소를 입력해야합니다.
    ///   - key: API KEY를 입력 해야합니다.
    ///   - configuration: foreground 에서 동작할지, background에서 동작할지 설정해야합니다.
    init(serverURL: String, key: String, configuration: URLSessionConfiguration = .default) {
        self.apiRequest = APIRequest(baseURL: serverURL, key: key, configuration: configuration)
    }
    
    /// 트래킹 토큰 생성
    /// - Returns: 트래킹 토큰 값을 반환합니다.
    public func getToken() -> String {
        return apiRequest.getToken()
    }
    
    /// 트래킹을 시작합니다.
    /// - Parameter completion: 정상적으로 서버와 통신할 경우 True를 반환합니다.
    public func start(completion: @escaping (Result<Bool, Error>) -> Void) {
        apiRequest.startTracking { result in
            switch result {
            case .success(let isSuccess):
                self.startLocationTracking()
                completion(.success(isSuccess))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func startLocationTracking() {
        locationManager = LocationManager(apiRequest: apiRequest)
        locationManager?.requestLocationAccess()
    }
    
    /// 트래킹을 종료합니다.
    /// - Parameter completion: 정상적으로 서버와 통신할 경우 True를 반환합니다.
    public func end(completion: @escaping (Result<Bool, Error>) -> Void) {
        apiRequest.stopTracking { result in
            switch result {
            case .success(let isSuccess):
                self.locationManager?.stopUpdatingLocation()
                completion(.success(isSuccess))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 좌표를 반환합니다.
    /// - Parameter completion: completion으로 CLLocation 좌표를 반환합니다.
    public func getLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        apiRequest.getTrackingInfo { result in
            switch result {
            case .success(let locations):
                completion(.success(locations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

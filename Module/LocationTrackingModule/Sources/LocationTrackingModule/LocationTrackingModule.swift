// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine
import CoreLocation

public class LocationTrackingModule {
    private let apiRequest: APIRequest
    private var locationManager: LocationManager?
    
    var apiKey: String {
        apiRequest.key ?? "nil"
    }
    var token: String{
        apiRequest.token ?? "nil"
    }
    
    
    /// LocationTrackingModule 생성시 토큰이 발행됩니다.
    /// - Parameters:
    ///   - serverURL: 서버 주소를 입력해야합니다.
    ///   - key: API KEY를 입력 해야합니다.
    ///   - configuration: foreground 에서 동작할지, background에서 동작할지 설정해야합니다.
    public init(serverURL: String, key: String? = nil , configuration: URLSessionConfiguration = .default) {
        self.apiRequest = APIRequest(baseURL: serverURL, key: key, configuration: configuration)
        
    }
    
    /// 트래킹 토큰 생성
    /// - Returns: 트래킹 토큰 값을 반환합니다.
    public func getToken() -> String {
        return token
    }
    
    /// 트래킹을 시작합니다.
    /// - Parameter completion: 정상적으로 서버와 통신할 경우 True를 반환합니다.
    public func start(startLatitude: Double, startLongitude: Double, endLatitude: Double, endLongitude: Double, estimatedArrivalTime: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
            apiRequest.startTracking(startLatitude: startLatitude, startLongitude: startLongitude, endLatitude: endLatitude, endLongitude: endLongitude, estimatedArrivalTime: estimatedArrivalTime) { result in
                switch result {
                case .success(let isSuccess):
                    self.locationManager = LocationManager(apiRequest: self.apiRequest)
                    self.locationManager?.requestLocationAccess()
                    completion(.success(isSuccess))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
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
    public func getLocation(pairToken: String , completion: @escaping (Result<CLLocation, Error>) -> Void) {
        apiRequest.getTrackingInfo(pairToken: pairToken) { result in
            switch result {
            case .success(let locations):
                completion(.success(locations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

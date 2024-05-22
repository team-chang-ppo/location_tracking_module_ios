//
//  APIClient.swift
//
//
//  Created by 승재 on 5/20/24.
//import Foundation
import Combine
import Foundation
import CoreLocation

final class APIRequest {
    let baseURL: String
    let key: String
    var token: String?
    let networkService: NetworkService
    var cancellables = Set<AnyCancellable>()
    
    init(baseURL: String, key: String, configuration: URLSessionConfiguration = .default) {
        self.baseURL = baseURL
        self.key = key
        self.networkService = NetworkService(configuration: configuration)
        self.generateToken { completion in
            switch completion {
            case .success(let token):
//                print("token :: \(token)")
                self.token = token
            case .failure(let error):
//                print("APIRequest >> \(error.localizedDescription)")
                break
            }
        }
        print("\(baseURL)\n\(key)\n\(token)\n")
    }
    func getToken() -> String {
        return self.token ?? "token이 없습니다."
    }
    private func generateToken(completion: @escaping (Result<String, Error>) -> Void) {
        let tokenRequestData: [String: Any] = [
            "identifier": "DEFAULT",
            "scope": ["WRITE_TRACKING_COORDINATE", "READ_TRACKING_COORDINATE"]
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: tokenRequestData, options: []) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let resource = Resource<APIResponse<TokenResult>>(
            base: baseURL,
            path: "/api/tracking/v1/generate-token",
            params: [:],
            header: ["Content-Type": "application/json", "APIKEY": key],
            httpMethod: .POST,
            body: bodyData
        )
        
        networkService.load(resource)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completionResult in
                switch completionResult {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response!.data.token))
            })
            .store(in: &cancellables)
    }
    
    func startTracking(startLatitude: Double, startLongitude: Double, endLatitude: Double, endLongitude: Double, estimatedArrivalTime: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
            guard let token = self.token else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }

            let bodyData: [String: Any] = [
                "startLatitude": startLatitude,
                "startLongitude": startLongitude,
                "endLatitude": endLatitude,
                "endLongitude": endLongitude,
                "estimatedArrivalTime": estimatedArrivalTime
            ]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: bodyData, options: []) else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }

            let resource = Resource<APIResponse<ErrorResponse>>(
                base: baseURL,
                path: "/api/tracking/v1/start",
                params: [:],
                header: ["Content-Type": "application/json", "Authorization": "Bearer \(token)"],
                httpMethod: .POST,
                body: jsonData
            )
            
            networkService.load(resource)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completionResult in
                    switch completionResult {
                    case .failure(let error):
                        completion(.failure(error))
                    case .finished:
                        break
                    }
                }, receiveValue: { response in
                    if response?.msg == nil {
                        completion(.success(true))
                    } else {
                        let errorMsg = response?.msg ?? "nil Error msg"
                        completion(.failure(NetworkError.serverError(message: errorMsg)))
                    }
                })
                .store(in: &cancellables)
        }
    
    func sendTrackingData(data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = self.token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let bodyData = try? JSONSerialization.data(withJSONObject: data, options: [])
        
        let resource = Resource<APIResponse<StartStopResult>>(
            base: baseURL,
            path: "/api/tracking/v1/tracking",
            params: [:],
            header: ["Content-Type": "application/json", "Authorization": "Bearer \(token)"],
            httpMethod: .POST,
            body: bodyData
        )
        
        networkService.load(resource)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completionResult in
                switch completionResult {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    completion(.success(()))
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func stopTracking(completion: @escaping (Result<Bool, Error>) -> Void) {
            guard let token = self.token else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
            
            let resource = Resource<APIResponse<ErrorResponse>>(
                base: baseURL,
                path: "/api/tracking/v1/end",
                params: [:],
                header: ["Content-Type": "application/json", "Authorization": "Bearer \(token)"],
                httpMethod: .GET,
                body: nil
            )
            
        networkService.load(resource)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completionResult in
                switch completionResult {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { response in
                if response?.msg == nil {
                    completion(.success(true))
                } else {
                    let errorMsg = response?.msg ?? "nil Error msg"
                    completion(.failure(NetworkError.serverError(message: errorMsg)))
                }
            })
            .store(in: &cancellables)
        }
    
    func getTrackingInfo(pairToken: String , completion: @escaping (Result<CLLocation, Error>) -> Void) {

        let resource = Resource<APIResponse<TrackingInfoResult>>(
            base: baseURL,
            path: "/api/tracking/v1/tracking",
            params: [:],
            header: ["Content-Type": "application/json", "Authorization": "Bearer \(pairToken)"],
            httpMethod: .GET,
            body: nil
        )
        
        networkService.load(resource)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completionResult in
                switch completionResult {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { response in
                let result = CLLocation(latitude: response!.data.latitude,
                                        longitude: response!.data.longitude)
                completion(.success(result))
            })
            .store(in: &cancellables)
    }
}

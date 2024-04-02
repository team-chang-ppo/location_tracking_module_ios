//
//  NetworkService.swift
//  LocationApp
//
//  Created by 승재 on 3/13/24.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case responseError(statusCode: Int)
    case jsonDecodingError(error: Error)
}

final class NetworkService {
    
    // Connect Post
    func sendConnectRequest(requestRoute: ConnectRequest  , completion: @escaping (Result<String, NetworkError>) -> Void) {
        let url = "\(APIConstants.BaseURL)/api/tracking/v1/connect"
        
        let request = requestRoute
        
        AF.request(url,
                   method: .post,
                   parameters: request,
                   encoder: JSONParameterEncoder.default,
                   headers: nil)
               .responseDecodable(of: ConnectResponse.self) { response in
            switch response.result {
            case .success(let data):
                self.saveAccessToken(token: data.accessToken)
                completion(.success(data.accessToken))
            case .failure(let error):
                if let httpStatusCode = response.response?.statusCode {
                    completion(.failure(.responseError(statusCode: httpStatusCode)))
                } else if let afError = error.asAFError, afError.isResponseSerializationError {
                    // JSON 디코딩 오류
                    completion(.failure(.jsonDecodingError(error: error)))
                } else {
                    // 기타 오류
                    completion(.failure(.invalidResponse))
                }
            }
        }
    }
    
    // Tracking Post
    func sendTrackingRequest(trackingRequest: TrackingRequest, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let url = "\(APIConstants.BaseURL)/api/tracking/v1/tracking"
        let request = trackingRequest

        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(accessToken)"
            ]

            AF.request(url,
                       method: .post,
                       parameters: request,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
                .response { response in
                    switch response.result {
                    case .success(_):
                        if let httpStatusCode = response.response?.statusCode, httpStatusCode == 200 {
                            completion(.success(true))
                        } else {
                            if let httpStatusCode = response.response?.statusCode {
                                completion(.failure(.responseError(statusCode: httpStatusCode)))
                            } else {
                                completion(.failure(.invalidResponse))
                            }
                        }
                    case .failure(let error):
                        if let afError = error.asAFError, afError.isResponseSerializationError {
                            completion(.failure(.jsonDecodingError(error: error)))
                        } else {
                            completion(.failure(.invalidResponse))
                        }
                    }
                }
        } else {
            // "accessToken"이 UserDefaults에 없는 경우
            completion(.failure(.invalidRequest))
        }
    }
    
    // Connect Delete
    func sendDisConnectRequest(completion: @escaping (Result<String, NetworkError>) -> Void) {
        let url = "\(APIConstants.BaseURL)/api/tracking/v1/tracking"

        AF.request(url,
                   method: .delete,
                   parameters: nil,
                   headers: nil)
            .response { response in
                switch response.result {
                case .success:
                    if let httpStatusCode = response.response?.statusCode, httpStatusCode == 200 {
                        completion(.success("Disconnected"))
                    } else {
                        completion(.failure(.responseError(statusCode: response.response?.statusCode ?? 0)))
                    }
                case .failure(let error):
                    if let afError = error.asAFError, afError.isResponseSerializationError {
                        completion(.failure(.jsonDecodingError(error: error)))
                    } else {
                        completion(.failure(.invalidResponse))
                    }
                }
            }
    }
    
    private func saveAccessToken(token: String) {
        // UserDefaults를 사용하여 accessToken 저장
        UserDefaults.standard.set(token, forKey: "accessToken")
    }
}

//
//  NetworkService.swift
//
//
//  Created by 승재 on 5/20/24.
//

import Foundation
import Combine

struct Resource<T: Decodable> {
    var base: String
    
    var path: String
    var params: [String: String]
    var header: [String: String]
    var httpMethod: HTTPMethod
    var body: Data?
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: base + path)!
        // MARK - 수정 필요
//        urlComponents.port = 8080
        let queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if httpMethod == .POST, let body = body {
            request.httpBody = body
        }
        
        header.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}

final class NetworkService {
    let session: URLSession
    var apiRequest: APIRequest? // APIRequest 인스턴스를 저장하기 위한 변수

    init(configuration: URLSessionConfiguration = .default) {
        session = URLSession(configuration: configuration)
    }
    
    func load<T>(_ resource: Resource<APIResponse<T>>) -> AnyPublisher<T?, Error> {
        guard let request = resource.urlRequest else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: request)
            .tryMap { [weak self] result in
                print(String(data: result.data, encoding: .utf8) ?? "No Data")
                
                if let response = result.response as? HTTPURLResponse {
                    if let newToken = response.allHeaderFields["new-token"] as? String {
                        print("gd")
                        // 토큰 갱신
                        self?.apiRequest?.updateToken(newToken)
                        // 동일한 요청을 다시 보내기 위해 에러를 발생시킴
                        throw NetworkError.responseError(statusCode: 401)
                    }
                    
                    guard (200..<300).contains(response.statusCode) else {
                        throw NetworkError.responseError(statusCode: response.statusCode)
                    }
                }
                
                return result.data
            }
            .decode(type: APIResponse<T>.self, decoder: JSONDecoder())
            .tryMap { apiResponse in
                if let result = apiResponse.result {
                    return result
                } else if apiResponse.success == "false", let errorResponse = apiResponse.result as? ErrorResponse {
                    throw NetworkError.serverError(message: errorResponse.msg)
                } else if apiResponse.success == "true" {
                    return nil
                } else {
                    throw NetworkError.invalidRequest
                }
            }
            .eraseToAnyPublisher()
    }
}

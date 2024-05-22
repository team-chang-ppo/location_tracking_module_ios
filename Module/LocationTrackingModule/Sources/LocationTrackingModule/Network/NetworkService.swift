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
        urlComponents.port = 8080
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
    
    init(configuration: URLSessionConfiguration = .default) {
        session = URLSession(configuration: configuration)
    }
    
    func load<T>(_ resource: Resource<APIResponse<T>>) -> AnyPublisher<T?, Error> {
        guard let request = resource.urlRequest else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: request)
            .tryMap { result in
                print(String(data: result.data, encoding: .utf8) ?? "No Data")
                guard let response = result.response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode)
                else {
                    let response = result.response as? HTTPURLResponse
                    let statusCode = response?.statusCode ?? -1
                    throw NetworkError.responseError(statusCode: statusCode)
                }
                return result.data
            }
            .decode(type: APIResponse<T>.self, decoder: JSONDecoder())
            .tryMap { apiResponse in
                if let result = apiResponse.result {
                    return result
                } else if !apiResponse.success, let errorResponse = apiResponse.result as? ErrorResponse {
                    throw NetworkError.serverError(message: errorResponse.msg)
                } else if apiResponse.success {
                    return nil
                }
                
                else {
                    throw NetworkError.invalidRequest
                }
            }
            .eraseToAnyPublisher()
    }
}

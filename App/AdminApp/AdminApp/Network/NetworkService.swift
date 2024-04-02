//
//  NetworkService.swift
//  AdminApp
//
//  Created by 승재 on 3/29/24.
//
import Foundation
import Combine

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case responseError(statusCode: Int)
    case jsonDecodingError(error: Error)
}

final class NetworkService{
    let session: URLSession
    
    init(configuration: URLSessionConfiguration){
        session = URLSession(configuration: .default)
    }
    
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        guard let request = resource.urlRequest else{
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: request)
            .tryMap { result in
                print(String(data: result.data, encoding: .utf8) ?? "No Data")
                guard let response = result.response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode)
                else{
                    let response = result.response as? HTTPURLResponse
                    let statusCode = response?.statusCode ?? -1
                    throw NetworkError.responseError(statusCode: statusCode)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

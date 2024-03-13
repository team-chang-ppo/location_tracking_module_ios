//
//  NetworkService.swift
//  LocationApp
//
//  Created by 승재 on 3/13/24.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case responseError(statusCode: Int)
    case jsonDecodingError(error: Error)
}

final class NetworkService {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    
    func RequestData<T>(urlResource: URLResource<T>) async throws -> T where T: Decodable {
        guard let request = urlResource.urlRequest else {
            throw NetworkError.invalidRequest
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.responseError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            throw NetworkError.jsonDecodingError(error: error)
        }
    }
}

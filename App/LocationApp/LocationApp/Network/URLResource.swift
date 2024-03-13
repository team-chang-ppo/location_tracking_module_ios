//
//  URLResource.swift
//  LocationApp
//
//  Created by 승재 on 3/13/24.
//

import Foundation

struct URLResource<T: Decodable> {
    
    var base: String
    var path: String
    var params: [String: String]
    var header: [String: String]
    var method: HTTPMethod
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    var urlRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: base + path) else { return nil }
        
        let queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        header.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    init(base: String,
         path: String,
         params: [String: String] = [:],
         header: [String: String] = [:],
         method: HTTPMethod = .GET)
    {
        self.base = base
        self.path = path
        self.params = params
        self.header = header
        self.method = method
    }
}

//
//  Resource.swift
//  AdminApp
//
//  Created by 승재 on 3/29/24.
//

import Foundation

enum HTTPMethod : String {
    case GET
    case POST
    case DELETE
    case PUT
}

struct Resource<T: Decodable> {
    var base: String
    var path: String
    var params: [String: String]
    var header: [String: String]
    var httpMethod: HTTPMethod
    var body: Data? // JSON 데이터를 위한 새로운 속성
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: base + path)!
        let queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        // 쿠키로 sessionID 설정
        if let sessionID = AuthManager.shared.getSessionID() {
            request.addValue("JSESSIONID=\(sessionID)", forHTTPHeaderField: "Cookie")
        }
        
        // POST 요청인 경우, 요청 본문에 JSON 데이터 추가
        if httpMethod == .POST, let body = body {
            request.httpBody = body
        }
        
        
        header.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}

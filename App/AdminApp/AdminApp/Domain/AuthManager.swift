//
//  AuthManager.swift
//  AdminApp
//
//  Created by 승재 on 3/18/24.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let sessionCookieURL = "https://example.com/api/request_api_key" // API 키를 요청할 URL
    }
    
    private init() {}
    
    public var isSignedIn: Bool {
        print("session ID = \(String(describing: getSessionID())) , APIKey = \(String(describing: getAPIKey()))")
        return getSessionID() != nil
    }
    
    public func requestAPIKey() async -> String? {
        guard let sessionID = getSessionID() else {
            print("SessionID is not available.")
            return nil
        }
        
        guard let url = URL(string: Constants.sessionCookieURL) else {
            print("URL is not valid.")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 쿠키 설정
        if let cookie = HTTPCookie(properties: [
            .domain: url.host!,
            .path: "/",
            .name: "JSESSIONID",
            .value: sessionID,
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 3600)
        ]) {
            request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: [cookie])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server")
                return nil
            }
            
            // API 키 추출 로직 (응답 형식에 따라 다름)
            if let apiKey = String(data: data, encoding: .utf8) {
                // API 키를 Keychain에 저장
                if let apiKeyData = apiKey.data(using: .utf8) {
                    KeychainManager.save(key: "APIKey", data: apiKeyData)
                }
                return apiKey
            } else {
                print("Failed to decode API key")
                return nil
            }
        } catch {
            print("Request failed with error: \(error)")
            return nil
        }
    }
    
    // Keychain에서 SessionID 가져오기
    public func getSessionID() -> String? {
        guard let sessionData = KeychainManager.load(key: "SessionID"),
              let sessionID = String(data: sessionData, encoding: .utf8) else {
            return nil
        }
        return sessionID
    }
    
    // Keychain에서 APIKey 가져오기
    public func getAPIKey() -> String? {
        guard let apiKeyData = KeychainManager.load(key: "APIKey"),
              let apiKey = String(data: apiKeyData, encoding: .utf8) else {
            return nil
        }
        return apiKey
    }
}

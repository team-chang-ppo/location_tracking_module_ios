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
        print("session ID = \(String(describing: getSessionID())) ")
        return getSessionID() != nil
    }
    
    // Keychain에서 SessionID 가져오기
    public func getSessionID() -> String? {
        guard let sessionData = KeychainManager.load(key: "SessionID"),
              let sessionID = String(data: sessionData, encoding: .utf8) else {
            return nil
        }
        return sessionID
    }
    
}

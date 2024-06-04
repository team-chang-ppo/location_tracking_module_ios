//
//  File.swift
//  
//
//  Created by 승재 on 5/22/24.
//

import Foundation

// APIResponse 구조체
public struct APIResponse<T: Codable>: Codable {
    public let success: String
    public let result: T?
}

// 기타 관련 구조체
//public struct TokenResult: Codable {
//    public let data: TokenData
//}

public struct TokenData: Codable {
    public let token: String
}

public struct StartStopResult: Codable {
    let success: String
    let result: ErrorResponse?
}

//public struct TrackingInfoResult: Codable {
//    public let data: TrackingInfoData
//}

public struct TrackingInfoData: Codable {
    public let latitude: Double
    public let longitude: Double
}

public struct ErrorResponse: Codable {
    public let msg: String
}

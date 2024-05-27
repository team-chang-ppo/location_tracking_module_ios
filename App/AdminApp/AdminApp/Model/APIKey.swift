//
//  APIKey.swift
//  AdminApp
//
//  Created by 승재 on 3/20/24.
//

import Foundation

struct APIKeyDeleteResponse: Codable {
    let success: String
}

struct APIKeyListResponse: Codable {
    let success: String
    let result: APIKeyData
}
//
//
//struct APIKeyListResult: Codable {
//    let data: APIKeyData
//}

struct APIKeyData: Codable {
    let numberOfElements: Int
    let hasNext: Bool
    let apiKeyList: [APICard]
}

struct APICard: Codable, Hashable {
    let id: Int
    let value: String
    let grade: String
    let paymentFailureBannedAt: String?
    let cardDeletionBannedAt: String?
    let createdAt: String
}


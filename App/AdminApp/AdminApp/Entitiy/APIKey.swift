//
//  APIKey.swift
//  AdminApp
//
//  Created by 승재 on 3/20/24.
//

import Foundation

struct APIKeyListResponse: Codable {
    let success: Bool
    let code: String
    let result: APIKeyListResult
}

struct APIKeyListResult: Codable {
    let data: APIKeyData
}

struct APIKeyData: Codable {
    let numberOfElements: Int
    let hasNext: Bool
    let apiKeyList: [APICard]
}

struct APICard: Codable, Identifiable {
    let id: Int
    let value: String
    let grade: String
    let paymentFailureBannedAt: String?
    let cardDeletionBannedAt: String?
    let createdAt: String
}


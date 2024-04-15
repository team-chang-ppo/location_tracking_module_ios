//
//  CardListResponse.swift
//  AdminApp
//
//  Created by 승재 on 4/6/24.
//

import Foundation

struct CardListResponse: Codable {
    let success: Bool
    let code: String
    let result: CardListResult
}

struct CardListResult: Codable {
    let data: CardListData
}

struct CardListData: Codable {
    let cardList: [Card]
}

struct Card: Codable, Hashable {
    let id: Int
    let type: String
    let issuerCorporation: String
    let bin: String
    let paymentGateway: String
    let createdAt: String
}

//
//  CardListResponse.swift
//  AdminApp
//
//  Created by 승재 on 4/6/24.
//

import Foundation

struct CardListResponse: Codable {
    let success: String
    let result: CardListData
}

//struct CardListResult: Codable {
//    let data: CardListData
//}

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

struct CardRegisterResponse: Codable {
    let success: String
    let result: Card
}

//struct CardRegisterResult: Codable {
//    let data: Card
//}

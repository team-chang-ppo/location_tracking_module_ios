//
//  PaymentHistoryResponse.swift
//  AdminApp
//
//  Created by 승재 on 5/14/24.
//

import Foundation


struct PaymentHistoryResponse: Codable {
    let success: Bool
    let code: String
    let result: PaymentHistoryResult
}

struct PaymentHistoryResult: Codable {
    let data: PaymentHistoryData
}

struct PaymentHistoryData: Codable {
    let numberOfElements: Int
    let hasNext: Bool
    let paymentList: [PaymentHistory]
}

struct PaymentHistory: Hashable, Codable{
    
    let id: Int
    let amount: Int
    var status: String
    let startedAt: String
    let endedAt: String
    let cardInfo: CardInfo
    let createdAt: String
    
    func formattedDateRange() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let startDate = dateFormatter.date(from: startedAt),
              let endDate = dateFormatter.date(from: endedAt) else {
            return nil
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MM/dd"
        
        let startString = displayFormatter.string(from: startDate)
        let endString = displayFormatter.string(from: endDate)
        
        return "\(startString) ~ \(endString)"
    }
    
}

struct CardInfo: Codable, Hashable {
    let type: String
    let issuerCorporation: String
    let bin: String
}



struct RepaymentResponse: Codable {
    let success: Bool
    let code: String
    let result: RepaymentResponseResult
}

struct RepaymentResponseResult: Codable {
    let data: PaymentHistory
}

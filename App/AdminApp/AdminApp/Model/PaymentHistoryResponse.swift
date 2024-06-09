//
//  PaymentHistoryResponse.swift
//  AdminApp
//
//  Created by 승재 on 5/14/24.
//
import Foundation

struct PaymentHistoryResponse: Codable {
    let success: String
    let result: PaymentHistoryData
}

struct PaymentHistoryData: Codable {
    let numberOfElements: Int
    let hasNext: Bool
    let paymentList: [PaymentHistory]
}

struct PaymentHistory: Hashable, Codable {
    let id: Int
    let amount: Int
    var status: String
    let startedAt: String
    let endedAt: String
    let cardInfo: CardInfo?
    let createdAt: String
    
    func formattedDateRange() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let utcStartDate = dateFormatter.date(from: startedAt),
              let utcEndDate = dateFormatter.date(from: endedAt) else {
            return nil
        }
        
        dateFormatter.timeZone = TimeZone.current
        let localStartDate = dateFormatter.string(from: utcStartDate)
        let localEndDate = dateFormatter.string(from: utcEndDate)
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MM/dd"
        
        guard let startDate = dateFormatter.date(from: localStartDate),
              let endDate = dateFormatter.date(from: localEndDate) else {
            return nil
        }
        
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
    let success: String
    let result: PaymentHistory
}

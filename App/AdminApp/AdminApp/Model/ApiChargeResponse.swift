//
//  File.swift
//  AdminApp
//
//  Created by 승재 on 4/9/24.
//

import Foundation

// MARK: - Welcome
struct ApiChargeResponse: Codable {
    let success: String
    let result: ApiChargeResponseResult
    
    static func generateDummyData() -> ApiChargeResponse {
            let hours1 = [
                HourResult(hour: 1, cost: 220, count: 22),
                HourResult(hour: 2, cost: 770, count: 77),
                HourResult(hour: 5, cost: 400, count: 40)
            ]
            let hours2 = [
                HourResult(hour: 3, cost: 150, count: 15),
                HourResult(hour: 4, cost: 350, count: 35)
            ]
            
            let dayChargesApril = (1...30).map { day in
                DayCharge(date: "2024-04-\(String(format: "%02d", day))", hours: hours1, totalCount: 139, totalCost: 1390)
            }
            let dayChargesMay = (1...31).map { day in
                DayCharge(date: "2024-05-\(String(format: "%02d", day))", hours: hours2, totalCount: 139, totalCost: 1390)
            }
            let dayChargesJune = (1...30).map { day in
                DayCharge(date: "2024-06-\(String(format: "%02d", day))", hours: hours1, totalCount: 139, totalCost: 1390)
            }
            
            let apiKeys = [
                ApiChargeKeys(apiKey: 1, dayCharges: dayChargesApril + dayChargesMay + dayChargesJune, totalCost: 41700, totalCount: 4170),
                ApiChargeKeys(apiKey: 2, dayCharges: dayChargesApril + dayChargesMay + dayChargesJune, totalCost: 41700, totalCount: 4170)
            ]
            
            let result = ApiChargeResponseResult(memberID: 1, apiKeys: apiKeys, totalCost: 83400, totalCount: 8340)
            
            return ApiChargeResponse(success: "true", result: result)
        }
}

// MARK: - Result
struct ApiChargeResponseResult: Codable {
    let memberID: Int
    let apiKeys: [ApiChargeKeys?]
    let totalCost, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case apiKeys, totalCost, totalCount
    }
}

// MARK: - APIKey
struct ApiChargeKeys: Codable {
    let apiKey: Int
    let dayCharges: [DayCharge]
    let totalCost, totalCount: Int
}

// MARK: - DayCharge
struct DayCharge: Codable {
    let date: String
    let hours: [HourResult]
    let totalCount, totalCost: Int
}

// MARK: - Hour
struct HourResult: Codable {
    let hour, cost, count: Int
}

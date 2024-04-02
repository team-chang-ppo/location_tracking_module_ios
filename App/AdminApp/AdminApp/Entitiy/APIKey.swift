//
//  APIKey.swift
//  AdminApp
//
//  Created by 승재 on 3/20/24.
//

import Foundation

struct APICard: Hashable{
    let key: String
    let startDate: Date?
    let expirationDate : Date?
}

extension APICard {
    
    static let list: [APICard] = [
        APICard(key: "8AE919715776F8A4353F9C2902216489", startDate: createDate(year: 2024, month: 3, day: 20), expirationDate: createDate(year: 2024, month: 4, day: 20)),
        APICard(key: "1AE919715776F8A4353F9C2800216489", startDate: createDate(year: 2024, month: 3, day: 20), expirationDate: createDate(year: 2024, month: 4, day: 20)),
        APICard(key: "8AE919715776F8A4353F9C3909216489", startDate: createDate(year: 2024, month: 3, day: 20), expirationDate: createDate(year: 2024, month: 4, day: 20)),
        APICard(key: "4LB919715776F8A4353F9C5905216489", startDate: createDate(year: 2024, month: 3, day: 20), expirationDate: createDate(year: 2024, month: 4, day: 20)),
        APICard(key: "8JE929715776F8A4353F9C2934216489", startDate: createDate(year: 2024, month: 3, day: 20), expirationDate: createDate(year: 2024, month: 4, day: 20)),
        APICard(key: "5TE919715776F8A4353F9C1901216489", startDate: createDate(year: 2024, month: 3, day: 20), expirationDate: createDate(year: 2024, month: 4, day: 20)),
        APICard(key: "5TE919715776F8A4353F931901216489", startDate: createDate(year: 2024, month: 3, day: 20), expirationDate: createDate(year: 2024, month: 4, day: 20)),
        
        
    ]
    private static func createDate(year: Int, month: Int, day: Int) -> Date {
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            return Calendar.current.date(from: dateComponents)!
        }
}

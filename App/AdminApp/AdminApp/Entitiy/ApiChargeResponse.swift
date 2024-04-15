//
//  File.swift
//  AdminApp
//
//  Created by 승재 on 4/9/24.
//


import Foundation

struct ApiResponse: Codable {
    let currency: String
    let totalAmount: Int
    let apiKeys: [ApiKey]
    static func generateDummyData() -> ApiResponse {
        let charges1 = [
            Charge(date: "2024-04-01", amount: 300),
            Charge(date: "2024-04-02", amount: 650),
            Charge(date: "2024-04-03", amount: 200),
            Charge(date: "2024-04-04", amount: 150),
            Charge(date: "2024-04-05", amount: 300),
            Charge(date: "2024-04-06", amount: 650),
            Charge(date: "2024-04-07", amount: 700),
            Charge(date: "2024-04-08", amount: 850),
            Charge(date: "2024-04-09", amount: 900),
            Charge(date: "2024-04-10", amount: 150),
            Charge(date: "2024-04-11", amount: 200),
            Charge(date: "2024-04-12", amount: 350),
            Charge(date: "2024-04-13", amount: 400),
            Charge(date: "2024-04-14", amount: 250),
            Charge(date: "2024-04-15", amount: 300),
            Charge(date: "2024-04-16", amount: 150),
            Charge(date: "2024-04-17", amount: 700),
            Charge(date: "2024-04-18", amount: 450),
            Charge(date: "2024-04-19", amount: 800),
            Charge(date: "2024-04-21", amount: 250),
            Charge(date: "2024-04-22", amount: 100),
            Charge(date: "2024-04-23", amount: 350),
            Charge(date: "2024-04-24", amount: 450),
            Charge(date: "2024-04-25", amount: 500),
            Charge(date: "2024-04-26", amount: 750),
            Charge(date: "2024-04-27", amount: 100),
            Charge(date: "2024-04-28", amount: 250),
            Charge(date: "2024-04-29", amount: 300),
            Charge(date: "2024-04-30", amount: 450),
            Charge(date: "2024-02-01", amount: 100),
            Charge(date: "2024-02-02", amount: 250),
            Charge(date: "2024-02-03", amount: 300),
            Charge(date: "2024-02-04", amount: 250),
            Charge(date: "2024-02-05", amount: 400),
            Charge(date: "2024-02-06", amount: 650),
            Charge(date: "2024-02-07", amount: 300),
            Charge(date: "2024-02-08", amount: 150),
            Charge(date: "2024-02-09", amount: 100),
            Charge(date: "2024-02-10", amount: 250),
            Charge(date: "2024-02-11", amount: 300),
            Charge(date: "2024-02-12", amount: 250),
            Charge(date: "2024-02-13", amount: 400),
            Charge(date: "2024-02-14", amount: 650),
            Charge(date: "2024-02-15", amount: 700),
            Charge(date: "2024-02-16", amount: 250),
            Charge(date: "2024-02-17", amount: 100),
            Charge(date: "2024-02-18", amount: 550),
            Charge(date: "2024-02-19", amount: 300),
            Charge(date: "2024-02-21", amount: 650),
            Charge(date: "2024-02-22", amount: 500),
            Charge(date: "2024-02-23", amount: 750),
            Charge(date: "2024-02-24", amount: 450),
            Charge(date: "2024-02-25", amount: 100),
            Charge(date: "2024-02-26", amount: 650),
            Charge(date: "2024-02-27", amount: 200),
            Charge(date: "2024-02-28", amount: 250),
            Charge(date: "2024-03-01", amount: 600),
            Charge(date: "2024-03-02", amount: 250),
            Charge(date: "2024-03-03", amount: 300),
            Charge(date: "2024-03-04", amount: 450),
            Charge(date: "2024-03-05", amount: 500),
            Charge(date: "2024-03-06", amount: 650),
            Charge(date: "2024-03-07", amount: 700),
            Charge(date: "2024-03-08", amount: 850),
            Charge(date: "2024-03-09", amount: 100),
            Charge(date: "2024-03-10", amount: 250),
            Charge(date: "2024-03-11", amount: 300),
            Charge(date: "2024-03-12", amount: 450),
            Charge(date: "2024-03-13", amount: 500),
            Charge(date: "2024-03-14", amount: 650),
            Charge(date: "2024-03-15", amount: 700),
            Charge(date: "2024-03-16", amount: 250),
            Charge(date: "2024-03-17", amount: 100),
            Charge(date: "2024-03-18", amount: 250),
            Charge(date: "2024-03-19", amount: 300),
            Charge(date: "2024-03-21", amount: 450),
            Charge(date: "2024-03-22", amount: 500),
            Charge(date: "2024-03-23", amount: 650),
            Charge(date: "2024-03-24", amount: 450),
            Charge(date: "2024-03-25", amount: 500),
            Charge(date: "2024-03-26", amount: 650),
            Charge(date: "2024-03-27", amount: 700),
            Charge(date: "2024-03-28", amount: 250),
            Charge(date: "2024-03-29", amount: 100),
            Charge(date: "2024-03-30", amount: 250),
            Charge(date: "2024-03-31", amount: 300),
        ]
        let charges2 = [
            Charge(date: "2024-04-01", amount: 200),
            Charge(date: "2024-04-02", amount: 250),
            Charge(date: "2024-04-03", amount: 300),
            Charge(date: "2024-04-04", amount: 350),
            Charge(date: "2024-04-05", amount: 500),
            Charge(date: "2024-04-06", amount: 150),
            Charge(date: "2024-04-07", amount: 700),
            Charge(date: "2024-04-08", amount: 850),
            Charge(date: "2024-04-09", amount: 500),
            Charge(date: "2024-04-10", amount: 450),
            Charge(date: "2024-04-11", amount: 300),
            Charge(date: "2024-04-12", amount: 250),
            Charge(date: "2024-04-13", amount: 800),
            Charge(date: "2024-04-14", amount: 750),
            Charge(date: "2024-04-15", amount: 300),
            Charge(date: "2024-04-16", amount: 450),
            Charge(date: "2024-04-17", amount: 500),
            Charge(date: "2024-04-18", amount: 650),
            Charge(date: "2024-04-19", amount: 100),
            Charge(date: "2024-04-21", amount: 250),
            Charge(date: "2024-04-22", amount: 300),
            Charge(date: "2024-04-23", amount: 450),
            Charge(date: "2024-04-24", amount: 550),
            Charge(date: "2024-04-25", amount: 600),
            Charge(date: "2024-04-26", amount: 750),
            Charge(date: "2024-04-27", amount: 800),
            Charge(date: "2024-04-28", amount: 950),
            Charge(date: "2024-04-29", amount: 100),
            Charge(date: "2024-04-30", amount: 250),
            Charge(date: "2024-02-01", amount: 400),
            Charge(date: "2024-02-02", amount: 550),
            Charge(date: "2024-02-03", amount: 600),
            Charge(date: "2024-02-04", amount: 750),
            Charge(date: "2024-02-05", amount: 800),
            Charge(date: "2024-02-06", amount: 950),
            Charge(date: "2024-02-07", amount: 100),
            Charge(date: "2024-02-08", amount: 250),
            Charge(date: "2024-02-09", amount: 300),
            Charge(date: "2024-02-10", amount: 450),
            Charge(date: "2024-02-11", amount: 500),
            Charge(date: "2024-02-12", amount: 650),
            Charge(date: "2024-02-13", amount: 700),
            Charge(date: "2024-02-14", amount: 850),
            Charge(date: "2024-02-15", amount: 900),
            Charge(date: "2024-02-16", amount: 150),
            Charge(date: "2024-02-17", amount: 200),
            Charge(date: "2024-02-18", amount: 350),
            Charge(date: "2024-02-19", amount: 400),
            Charge(date: "2024-02-21", amount: 550),
            Charge(date: "2024-02-22", amount: 600),
            Charge(date: "2024-02-23", amount: 750),
            Charge(date: "2024-02-24", amount: 850),
            Charge(date: "2024-02-25", amount: 100),
            Charge(date: "2024-02-26", amount: 250),
            Charge(date: "2024-02-27", amount: 300),
            Charge(date: "2024-02-28", amount: 250),
            Charge(date: "2024-03-01", amount: 100),
            Charge(date: "2024-03-02", amount: 450),
            Charge(date: "2024-03-03", amount: 300),
            Charge(date: "2024-03-04", amount: 450),
            Charge(date: "2024-03-05", amount: 500),
            Charge(date: "2024-03-06", amount: 650),
            Charge(date: "2024-03-07", amount: 700),
            Charge(date: "2024-03-08", amount: 850),
            Charge(date: "2024-03-09", amount: 100),
            Charge(date: "2024-03-10", amount: 250),
            Charge(date: "2024-03-11", amount: 300),
            Charge(date: "2024-03-12", amount: 450),
            Charge(date: "2024-03-13", amount: 200),
            Charge(date: "2024-03-14", amount: 650),
            Charge(date: "2024-03-15", amount: 730),
            Charge(date: "2024-03-16", amount: 240),
            Charge(date: "2024-03-17", amount: 160),
            Charge(date: "2024-03-18", amount: 2750),
            Charge(date: "2024-03-19", amount: 300),
            Charge(date: "2024-03-21", amount: 350),
            Charge(date: "2024-03-22", amount: 100),
            Charge(date: "2024-03-23", amount: 150),
            Charge(date: "2024-03-24", amount: 450),
            Charge(date: "2024-03-25", amount: 500),
            Charge(date: "2024-03-26", amount: 650),
            Charge(date: "2024-03-27", amount: 700),
            Charge(date: "2024-03-28", amount: 250),
            Charge(date: "2024-03-29", amount: 100),
            Charge(date: "2024-03-30", amount: 250),
            Charge(date: "2024-03-31", amount: 300),
        ]
        let apiKeys = [
            ApiKey(apiKey: "eyJhbGciOiJIUzI1NiJ9.eyJHUkFERV9UWVBFIjoiR1JBREVfRlJFRSIsIk1FTUJFUl9JRCI6MSwiSUQiOjEsImlhdCI6MTcxMjM5NjgxMX0.T8BAUfZU4b_i3AELLW8BZckFpAk2WB2jd8o4EtMwumg", charges: charges1),
            ApiKey(apiKey: "TShJf2GcpQFJIRr13odQ.TdGH3AFFGVHUVCBQKgqsAKJHRGFfSlWQW3RJKRyTEUWFQlASFgHJ2QawERQiOjEsImlhdCI6MTcxMjM5NjgxMX0.T8BAUfZU4b_i3AELLW8BZckFpAk2WB2jd8o4EtMwumg", charges: charges2)
        ]
        return ApiResponse(currency: "won", totalAmount: 700, apiKeys: apiKeys)
    }
}

struct ApiKey: Codable {
    let apiKey: String
    let charges: [Charge]
}

struct Charge: Codable {
    let date: String
    let amount: Int
}



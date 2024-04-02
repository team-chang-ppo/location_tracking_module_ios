//
//  ConnectRequest.swift
//  LocationApp
//
//  Created by 승재 on 4/1/24.
//

import Foundation

struct ConnectRequest: Codable {
    let identifier: String
    let startPoint: Point
    let endPoint: Point
    let estimatedArrivalTime: Int
}

struct Point: Codable {
    let x: Double
    let y: Double
}


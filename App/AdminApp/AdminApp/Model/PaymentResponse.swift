//
//  PaymentResponse.swift
//  AdminApp
//
//  Created by 승재 on 3/27/24.
//

import Foundation

struct PaymentResponse: Decodable {
    let ios_app_scheme: String
    let next_redirect_mobile_url: String?
}

struct DeleteCardResponse: Codable {
    let success : Bool
    let code: String
}

//
//  UserModel.swift
//  AdminApp
//
//  Created by 승재 on 4/6/24.
//

import Foundation


struct UserResponse: Codable {
    let success: Bool
    let code: String
    let result: UserData
}

struct UserData: Codable {
    let data: UserModel
}
struct UserModel: Codable, Hashable {
    let id: Int
    let name: String
    let username: String
    let profileImage: String
    let roles: [String]
    let paymentFailureBannedAt: String?
    let createdAt: String
}

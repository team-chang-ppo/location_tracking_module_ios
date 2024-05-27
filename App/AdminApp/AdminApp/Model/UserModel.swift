//
//  UserModel.swift
//  AdminApp
//
//  Created by 승재 on 4/6/24.
//

import Foundation


struct UserResponse: Codable {
    let success: String
    let result: UserProfile?
}


struct UserProfile: Codable, Hashable {
    let id: Int
    let name: String
    let username: String
    let profileImage: String
    let role: String
    let paymentFailureBannedAt: String?
    let createdAt: String
}

struct LogoutResponse: Codable {
    let success : String
}

struct DeleteUserResponse: Codable {
    let success: String
    let result: DeleteUser?
}

struct DeleteUser: Codable, Hashable {
    let id: Int
    let name: String
    let username: String
    let profileImage: String
    let role: String
    let paymentFailureBannedAt: String?
    let deleteRequestedAt : String?
    let createdAt: String
}

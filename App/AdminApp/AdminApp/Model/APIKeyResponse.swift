//
//  APIKeyResponse.swift
//  AdminApp
//
//  Created by 승재 on 5/10/24.
//

import Foundation

/*
 {
   "success": true,
   "code": "0",
   "result": {
     "data": {
       "id": 1,
       "value": "eyJhbGciOiJIUzI1NiJ9.eyJHUkFERV9UWVBFIjoiR1JBREVfRlJFRSIsIk1FTUJFUl9JRCI6MSwiSUQiOjEsImlhdCI6MTcxMjM5NjgxMX0.T8BAUfZU4b_i3AELLW8BZckFpAk2WB2jd8o4EtMwumg",
       "grade": "GRADE_FREE",
       "paymentFailureBannedAt": null,
       "cardDeletionBannedAt": null,
       "createdAt": "2024-04-06T18:46:51"
     }
   }
 }
 */

struct APIKeyResponse: Codable {
    let success: Bool
    let code: String
    let result: APIKeyResponseResult
}


struct APIKeyResponseResult: Codable {
    let data: APICard
}

//
//  PaymentResponse.swift
//  AdminApp
//
//  Created by 승재 on 3/27/24.
//

import Foundation

/*
 {
   "success": true,
   "code": "0",
   "result": {
     "data": {
       "nextRedirectAppUrl": "https://online-pay.kakao.com/mockup/v1/0572393ff8474c6a3a6174feb8e72908ab36c4a8455554b08c8d5c08ea61632c/aInfo",
       "nextRedirectMobileUrl": "https://online-pay.kakao.com/mockup/v1/0572393ff8474c6a3a6174feb8e72908ab36c4a8455554b08c8d5c08ea61632c/mInfo",
       "nextRedirectPcUrl": "https://online-pay.kakao.com/mockup/v1/0572393ff8474c6a3a6174feb8e72908ab36c4a8455554b08c8d5c08ea61632c/info",
       "androidAppScheme": "kakaotalk://kakaopay/pg?url=https://online-pay.kakao.com/pay/mockup/0572393ff8474c6a3a6174feb8e72908ab36c4a8455554b08c8d5c08ea61632c",
       "iosAppScheme": "kakaotalk://kakaopay/pg?url=https://online-pay.kakao.com/pay/mockup/0572393ff8474c6a3a6174feb8e72908ab36c4a8455554b08c8d5c08ea61632c"
     }
   }
 }
 */
struct PaymentResponse: Codable {
    let success: Bool
    let code: String
    let result: PaymentResponseResult
}
struct PaymentResponseResult: Codable {
    let data : PaymentResponseData
}
struct PaymentResponseData : Codable {
    let nextRedirectAppUrl: String
    let nextRedirectMobileUrl: String
    let nextRedirectPcUrl: String
    let androidAppScheme: String
    let iosAppScheme: String
}

struct DeleteCardResponse: Codable {
    let success : Bool
    let code: String
}

//
//  File.swift
//  AdminApp
//
//  Created by 승재 on 5/5/24.
//
import Foundation

enum ApiKeyContent{
    case copyPasteAPIKey
    case analyzeAPIKey
    case deleteAPIKey
}

struct APIKeyItem : Hashable{
    var title : String
    var content : ApiKeyContent
    static let list: [APIKeyItem] = [
        APIKeyItem(title: "API 키 번호", content: .copyPasteAPIKey),
        APIKeyItem(title: "분석", content: .analyzeAPIKey),
        APIKeyItem(title: "해지", content: .deleteAPIKey),
    ]
}

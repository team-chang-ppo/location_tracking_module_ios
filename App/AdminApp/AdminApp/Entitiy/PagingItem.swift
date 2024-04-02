//
//  PagingModel.swift
//  AdminApp
//
//  Created by 승재 on 3/27/24.
//

import Foundation
struct PagingItem : Hashable{
    var title: String
    var description: String
    var content: PageContent
    var iconName: String
    var color: customColor
    
}
enum PageContent{
    case costPage
    case registerCardPage
    case PurchaseAPIKeyPage
}

enum customColor{
    case red
    case gray
    case blue
    case green
}



extension PagingItem {
    static let list: [PagingItem] = [
        PagingItem(title: "이번 달 요금",
                   description: "1235 원",
                   content: .costPage,
                   iconName: "wonsign.circle.fill", color: .red),
        PagingItem(title: "카드 등록",
                   description: "카드를 등록하면 API KEY 구매할 수 있는 권한을 얻을 수 있어요 !",
                   content: .registerCardPage,
                   iconName: "person.text.rectangle.fill", color: .blue),
        PagingItem(title: "API 구매",
                   description: "API KEY를 구매 하여 위치 추적 기능을 쉽고 빠르게 사용 할 수 있어요 !",
                   content: .PurchaseAPIKeyPage,
                   iconName: "creditcard.circle.fill", color: .green),
    ]
}

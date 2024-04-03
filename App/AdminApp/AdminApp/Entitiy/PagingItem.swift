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
    var imageName: String?
    var iconImage: String?
    var color: ColorType
    
}
enum ColorType{
    case green
    case grey
    case lightblue
    case lightgreen
    case yellow
}
enum PageContent{
    case costPage
    case registerCardPage
    case purchaseAPIKeyPage
    case analyzeAPI
    case guide
}



extension PagingItem {
    static let list: [PagingItem] = [
        PagingItem(title: "4월 15일 명세서 요금",
                   description: "1,235원",
                   content: .costPage,
                   iconImage: "wonsign.square", color: .lightblue),
        
        PagingItem(title: "월간 정기결제 카드등록",
                   description: "카드등록으로 \n자동으로 결제할 수 있어요",
                   content: .registerCardPage,
                   iconImage: "person.text.rectangle",
                   color: .lightgreen),
        
        PagingItem(title: "API KEY 생성",
                   description: "위치 추적 기능을\n사용할 수 있어요",
                   content: .purchaseAPIKeyPage,
                   iconImage: "creditcard.circle",
                   color: .yellow),
        
        PagingItem(title: "API 사용 내역",
                   description: "어떤 API를 가장 많이\n사용했는지 확인할 수 있어요",
                   content: .analyzeAPI,
                   iconImage: "chart.bar.xaxis",
                   color: .green),
        PagingItem(title: "이용 가이드",
                   description: "Tracking API\n사용방법을 알아볼 수 있어요",
                   content: .guide,
                   imageName: "github_image",
                   color: .grey),
        
        
        
        
    ]
}

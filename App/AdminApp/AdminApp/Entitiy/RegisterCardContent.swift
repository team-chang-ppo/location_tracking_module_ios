//
//  RegisterCardContent.swift
//  AdminApp
//
//  Created by 승재 on 3/27/24.
//

import Foundation

struct RegisterCardContent{
    var title: String
    var description: String
}

extension RegisterCardContent{
    static let item: RegisterCardContent = RegisterCardContent(title: "정기 결제 카드 등록", description: "카카오 페이를 통해 Location Tracking Module을 사용할 수 있는 API KEY를 구매 할 수 있어요 !")
}

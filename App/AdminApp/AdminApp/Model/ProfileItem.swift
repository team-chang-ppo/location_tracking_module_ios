//
//  ProfileItem.swift
//  AdminApp
//
//  Created by 승재 on 4/29/24.
//

import Foundation

enum ProfileContent{
    case registerCardPage
    case paymentHistory
    case logout
    case deleteUser
}

struct ProfileItem : Hashable{
    var title : String
    var content : ProfileContent
    static let list: [ProfileItem] = [
        ProfileItem(title: "지불 방법 추가", content: .registerCardPage),
        ProfileItem(title: "결제 내역 조회", content: .paymentHistory)
    ]
    static let otherlist: [ProfileItem] = [
        ProfileItem(title: "기기 로그아웃", content: .logout),
        ProfileItem(title: "계정 탈퇴신청", content: .deleteUser),
//        ProfileItem(title: "개인정보 처리 방침", content: .logout)
    ]
}

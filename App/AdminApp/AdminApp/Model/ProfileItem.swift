//
//  ProfileItem.swift
//  AdminApp
//
//  Created by 승재 on 4/29/24.
//

import Foundation

enum ProfileContent{
    case registerCardPage
    case logout
    case deleteUser
}

struct ProfileItem : Hashable{
    var title : String
    var content : ProfileContent
    static let list: [ProfileItem] = [
        ProfileItem(title: "지불 방법 추가", content: .registerCardPage)
    ]
    static let otherlist: [ProfileItem] = [
        ProfileItem(title: "기기 로그아웃", content: .logout),
        ProfileItem(title: "회원 탈퇴", content: .deleteUser),
        ProfileItem(title: "개인정보 처리 방침", content: .logout)
    ]
}
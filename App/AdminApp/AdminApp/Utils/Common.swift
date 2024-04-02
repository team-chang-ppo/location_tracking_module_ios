//
//  Common.swift
//  AdminApp
//
//  Created by 승재 on 3/26/24.
//

import Foundation

struct Utils {
    static func dateToString(from date: Date?, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        guard let validDate = date else { return "Invalid date" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format // 원하는 날짜 형식 지정
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // 로케일 설정
        dateFormatter.timeZone = TimeZone.current // 현재 시간대 설정
        return dateFormatter.string(from: validDate)
    }
}

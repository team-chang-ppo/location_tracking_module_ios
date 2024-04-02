//
//  SampleRoute.swift
//  LocationApp
//
//  Created by 승재 on 4/1/24.
//

import Foundation

extension ConnectRequest{
    static let sampleRoute = ConnectRequest(
        identifier: "123456789",
        startPoint: Point(x: 36.14555210330884, y: 128.39238876753052),
        endPoint: Point(x: 36.137912259419835, y: 128.39714359438796),
        estimatedArrivalTime: 480 // 예상 도착 시간(분 단위)
    )
}

// Optional(36.14555210330884) , Optional(128.39238876753052)

//클릭 위치의 위도는 36.137912259419835, 경도는 128.39714359438796 입니다

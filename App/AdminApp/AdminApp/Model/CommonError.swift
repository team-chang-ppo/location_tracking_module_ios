//
//  CommonError.swift
//  AdminApp
//
//  Created by 승재 on 5/28/24.
//

import Foundation

enum CommonError: Error {
    case encodingFailed
    case networkFailure(Error)
    case invalidResponse
    case unknown
}

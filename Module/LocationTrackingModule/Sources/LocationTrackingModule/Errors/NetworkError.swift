//
//  File.swift
//  
//
//  Created by 승재 on 5/20/24.
//

import Foundation



public enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case responseError(statusCode: Int)
    case jsonDecodingError(error: Error)
    case serverError(message: String)
    
}

//
//  Common.swift
//  AdminApp
//
//  Created by 승재 on 3/26/24.
//

import Foundation

struct Utils {
    
    public static func utcToLocale(utcDate : String, dateFormat: String) -> String
    {
        let dfFormat = DateFormatter()
        dfFormat.dateFormat = dateFormat
        dfFormat.timeZone = TimeZone(abbreviation: "UTC")
        let dtUtcDate = dfFormat.date(from: utcDate)
        
        dfFormat.timeZone = TimeZone.current
        dfFormat.dateFormat = dateFormat
        return dfFormat.string(from: dtUtcDate!)
    }
    
    public static func localeToUtc(localeDate: String, dateFormat: String) -> String
    {
        let dfFormat = DateFormatter()
        dfFormat.dateFormat = dateFormat
        dfFormat.timeZone = TimeZone.current
        let dtLocaleDate = dfFormat.date(from: localeDate)
        
        dfFormat.timeZone = TimeZone(abbreviation: "UTC")
        dfFormat.dateFormat = dateFormat
        return dfFormat.string(from: dtLocaleDate!)
    }
}

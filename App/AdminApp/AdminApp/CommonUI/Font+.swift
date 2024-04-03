//
//  Font+.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import UIKit

extension UIFont{
    public enum PretendardType: String{
        case Black = "Black"
        case Bold = "Bold"
        case ExtraBold = "ExtraBold"
        case ExtraLight = "ExtraLight"
        case Light = "Light"
        case Medium = "Medium"
        case Regular = "Regular"
        case SemiBold = "SemiBold"
        case Thin = "Thin"
    }
    
    static func pretendard(_ type: PretendardType, size: CGFloat) -> UIFont{
        return UIFont(name: "Pretendard-\(type.rawValue)", size: size) ?? .systemFont(ofSize: size)
    }
}

//
//  Image+.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import UIKit

extension UIImage {
    static func imageWithColor(color: UIColor, width: CGFloat, height: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { context in
            color.setFill()
            context.fill(rect)
        }
    }
}

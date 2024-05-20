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
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // 가장 작은 비율 선택
        let ratio = min(widthRatio, heightRatio)
        
        // 새로운 크기 계산
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        // 새로운 크기의 이미지 컨텍스트 생성
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


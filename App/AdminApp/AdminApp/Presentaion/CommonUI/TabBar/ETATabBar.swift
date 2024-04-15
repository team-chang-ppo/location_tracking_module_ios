//
//  ETATabBar.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//

import UIKit
class ETATabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.addCurves()
    }
    private func addCurves() {
        let path = UIBezierPath()
        let width = self.frame.width
        let height: CGFloat = 60
        
        let startY: CGFloat = -20
        
        path.move(to: CGPoint(x: 0, y: height + startY))
        path.addQuadCurve(to: CGPoint(x: 10, y: 0),
                          controlPoint: CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: width - 10, y: 0))
        
        path.addQuadCurve(to: CGPoint(x: width, y: height + startY),
                          controlPoint: CGPoint(x: width, y: 0))
        
        path.addLine(to: CGPoint(x: width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.defaultCellColor.cgColor
        shapeLayer.strokeColor = UIColor.Grey500.withAlphaComponent(0.3).cgColor 
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }

}

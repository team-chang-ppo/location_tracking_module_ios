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
        let height: CGFloat = 60 // 탭바의 높이
        
        // 곡선의 시작점을 높이기 위해 y 값을 줄입니다 (화면 좌표계에서 위쪽으로 이동).
        let startY: CGFloat = -20 // 곡선의 시작점을 더 위로 조정
        
        // 왼쪽 곡선을 그립니다. 시작점을 높였습니다.
        path.move(to: CGPoint(x: 0, y: height + startY)) // 수정된 시작점
        // 제어점을 조정하여 곡선을 더 많이 휘게 합니다. 제어점의 X, Y 값을 조정해보세요.
        path.addQuadCurve(to: CGPoint(x: 10, y: 0),
                          controlPoint: CGPoint(x: 0, y: 0)) // 제어점을 조정
        
        // 왼쪽 곡선에서 오른쪽 곡선으로 직선을 그립니다.
        path.addLine(to: CGPoint(x: width - 10, y: 0))
        
        // 오른쪽 곡선을 그립니다. 시작점과 마찬가지로 끝점도 조정됩니다.
        path.addQuadCurve(to: CGPoint(x: width, y: height + startY), // 수정된 끝점
                          controlPoint: CGPoint(x: width, y: 0)) // 제어점을 조정
        
        // 곡선을 닫아줍니다.
        path.addLine(to: CGPoint(x: width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor { traitCollection -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return .Grey900 // 다크 모드에서 사용할 배경색
                default:
                    return .white // 라이트 모드에서 사용할 배경색
                }
            }.cgColor
        shapeLayer.strokeColor = UIColor.Grey500.withAlphaComponent(0.3).cgColor // 투명도를 추가
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }

}

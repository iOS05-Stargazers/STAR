//
//  GalaxyView.swift
//  star
//
//  Created by 안준경 on 3/31/25.
//

import UIKit

final class GalaxyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .black
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let maxRadiusX = rect.width * 0.6  // X축 최대 반지름 (타원형 변형)
        let maxRadiusY = rect.height * 0.5 // Y축 최대 반지름 (더 납작한 형태)
        let numberOfArms = 10
        let numberOfStars = 100
        
        for _ in 0..<numberOfStars {
            let armIndex = Int.random(in: 0..<numberOfArms)
            let angleOffset = CGFloat(armIndex) * (2 * .pi / CGFloat(numberOfArms))
            
            let t = CGFloat.random(in: 0...1) // 0에서 1까지의 위치
            let radiusX = t * maxRadiusX
            let radiusY = t * maxRadiusY
            let angle = t * 6 * .pi + angleOffset // 나선형 패턴
            
            let x = center.x + radiusX * cos(angle)
            let y = center.y + radiusY * sin(angle)
            
            let starSize = CGFloat.random(in: 0.3...2.2)
            let starRect = CGRect(x: x - starSize / 3, y: y - starSize / 2, width: starSize, height: starSize)
            
            let starColor = randomStarColor()
            context.setFillColor(starColor.cgColor)
            context.fillEllipse(in: starRect)
        }
    }
    
    func randomStarColor() -> UIColor {
        let colors: [UIColor] = [
            .white,
            UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0),  // 연한 블루
            UIColor(red: 1.0, green: 0.9, blue: 0.7, alpha: 1.0),  // 옅은 오렌지
            UIColor(red: 0.8, green: 0.7, blue: 1.0, alpha: 1.0)   // 연한 퍼플
        ]
        return colors.randomElement()!
    }
}

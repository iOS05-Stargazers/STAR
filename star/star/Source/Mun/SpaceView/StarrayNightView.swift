//
//  StarrayNightView.swift
//  star
//
//  Created by 서문가은 on 2/6/25.
//

import UIKit

final class StarryNightView: UIView {
    
    private var stars: [CAShapeLayer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        createStars()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    // 별 생성
    private func createStars() {
        let starCount = 40
        
        for _ in 0..<starCount {
            let star = createStar()
            stars.append(star)
            layer.addSublayer(star)
        }
        
        animateStars()
    }
    
    // 별(하나) 생성
    private func createStar() -> CAShapeLayer {
        let star = CAShapeLayer()
        star.fillColor = UIColor.white.cgColor
        star.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 2, height: 2)).cgPath
        
        let x = CGFloat.random(in: 0..<frame.width)
        let y = CGFloat.random(in: 0..<frame.height)
        star.position = CGPoint(x: x, y: y)
        
        return star
    }
    
    // 스타 회전 애니메이션
    private func animateStars() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 480
        rotation.repeatCount = .infinity
        
        layer.add(rotation, forKey: "starRotation")
    }
}

//
//  MeteorEffectView.swift
//  star
//
//  Created by 서문가은 on 2/6/25.
//  Refactored by 안준경 on 4/2/25.
//

import UIKit

final class MeteorEffectView: UIView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        createMeteor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    // 유성 생성
    private func createMeteor() {
        let startPoint = CGPoint(x:0, y: frame.height / 3.5) // 시작점
        let meteor = UIView()
        addSubview(meteor)
        
        let size = CGFloat(2)
        
        meteor.frame = CGRect(x: 0, y: 0, width: size, height: size)
        meteor.backgroundColor = .clear
        meteor.layer.cornerRadius = size / 2
        
        let trail = createMeteorTrail(color: .white)
        meteor.addSubview(trail)
        
        animateMeteor(meteor, from: startPoint)
    }
    
    // 유성 꼬리
    private func createMeteorTrail(color: UIColor) -> UIView {
        // 꼬리의 길이와 높이 설정
        let trailLength: CGFloat = 50
        let trailHeight: CGFloat = 2
        
        // 꼬리 뷰 생성 및 프레임 설정
        let trail = UIView(frame: CGRect(x: -trailLength, y: -trailHeight/2, width: trailLength, height: trailHeight))
        trail.backgroundColor = .clear
        
        // 그라데이션 레이어 설정
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = trail.bounds
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            color.withAlphaComponent(0.3).cgColor,
            color.withAlphaComponent(0.7).cgColor,
            color.cgColor
        ]
        
        // 그라데이션 방향을 가로로 설정
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // 블러 효과 추가
        trail.layer.addSublayer(gradientLayer)
        trail.layer.masksToBounds = false
        trail.layer.shadowColor = color.cgColor
        trail.layer.shadowOffset = .zero
        trail.layer.shadowRadius = 2
        trail.layer.shadowOpacity = 0.5
        
        // 꼬리 각도 회전
        trail.transform = CGAffineTransform(rotationAngle: .pi/5)

        return trail
    }
    
    // 유성 떨어지는 애니메이션
    private func animateMeteor(_ meteor: UIView, from startPoint: CGPoint) {
        let path = UIBezierPath()
        let endPoint = CGPoint(x: startPoint.x + frame.width, y: startPoint.y + frame.height / 3)

        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = Double(1.0) // 떨어지는 속도
        animation.beginTime = CACurrentMediaTime()
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            meteor.removeFromSuperview()
        }
        meteor.layer.add(animation, forKey: "meteorMotion")
        CATransaction.commit()
    }
}

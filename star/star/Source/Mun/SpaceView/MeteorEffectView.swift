//
//  MeteorEffectView.swift
//  star
//
//  Created by 서문가은 on 2/6/25.
//

import UIKit

class MeteorEffectView: UIView {
    
    private let colors: UIColor = .clear
    
    private let maxStarCount = 15
    private var meteorCount: Int = 4
    private var maxDelay: Double = 2
    private var minSpeed: Double = 2
    private var maxSpeed: Double = 3
    private var angle: Double = 30
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        createMeteors()
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
    private func createMeteors() {
        for _ in 0 ..< meteorCount {
            createMeteor()
        }
    }
    
    // 유성(하나) 생성
    private func createMeteor() {
        let meteor = UIView()
        meteor.translatesAutoresizingMaskIntoConstraints = false
        addSubview(meteor)
        
        // 랜덤 속성들
        let size = CGFloat(2 + Int.random(in: 0 ..< 2))
        let delay = Double.random(in: 0 ..< maxDelay)
        let duration = Double.random(in: minSpeed ..< maxSpeed)
        
        meteor.frame = CGRect(x: 0, y: 0, width: size, height: size)
        meteor.backgroundColor = colors
        meteor.layer.cornerRadius = size / 2
        
        // 유성 꼬리 추가
        let trail = createMeteorTrail(color: .white)
        meteor.addSubview(trail)
        
        // 유성 애니메이션
        animateMeteor(meteor, delay: delay, duration: duration)
    }
    
    // 유성 생성 생성
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
        
        // 대각선 방향으로 회전
        trail.transform = CGAffineTransform(rotationAngle: .pi/3.5)
        
        return trail
    }
    
    // 유성 애니메이션
    private func animateMeteor(_ meteor: UIView, delay: Double, duration: Double) {
            let path = UIBezierPath()
            
            // 시작 위치를 상단 또는 왼쪽에서 랜덤하게 선택
            let startFromTop = Bool.random()
            
            if startFromTop {
                // 상단에서 시작하는 경우
                let startX = CGFloat.random(in: 0..<frame.width)
                let endX = startX + frame.width
                path.move(to: CGPoint(x: startX, y: -10))
                path.addLine(to: CGPoint(x: endX, y: frame.height + 10))
            } else {
                // 왼쪽에서 시작하는 경우
                let startY = CGFloat.random(in: -10..<frame.height/2)
                let endY = startY + frame.height
                
                path.move(to: CGPoint(x: -10, y: startY))
                path.addLine(to: CGPoint(x: frame.width + 10, y: endY))
            }
            
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.path = path.cgPath
            animation.duration = duration
            animation.beginTime = CACurrentMediaTime() + delay
            animation.repeatCount = 1 // 무한 반복 대신 1번만 실행
            animation.calculationMode = .paced
            animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
            animation.isRemovedOnCompletion = true // 애니메이션 완료 후 제거
            animation.fillMode = .forwards
            
            // 애니메이션 완료 후 메테오 제거
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                meteor.removeFromSuperview()
            }
            meteor.layer.add(animation, forKey: "meteorMotion")
            CATransaction.commit()
            
            // 애니메이션이 끝나면 새로운 메테오 생성
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.createMeteor()
            }
        }
}

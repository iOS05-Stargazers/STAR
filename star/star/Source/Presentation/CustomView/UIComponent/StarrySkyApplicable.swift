//
//  StarrySkyApplicable.swift
//  star
//
//  Created by 안준경 on 4/8/25.
//

import UIKit

// StarrySky 이미지 백그라운드 설정 프로토콜
protocol StarrySkyApplicable: UIView {}

extension StarrySkyApplicable {
    
    func applyStarrySky(cloudAlpha: CGFloat = 0.1) {
        let starrySkyView = StarrySkyView()
        if let backgroundImage = starrySkyView.generateStarryBackground() {
            backgroundColor = UIColor(patternImage: backgroundImage)
        }
        setCloud(cloudAlpha)
    }
    
    private func setCloud(_ alpha: CGFloat) {
        // 이미지 넣기
        if let image = UIImage(named: "cloudImage") {
            
            let cloudImageView = UIImageView(image: image)
            
            if let height = cloudImageView.image?.size.height, let width = cloudImageView.image?.size.width {
                cloudImageView.alpha = alpha // 투명도 조절
                
                addSubview(cloudImageView)
                
                cloudImageView.snp.makeConstraints {
                    $0.centerX.centerY.equalToSuperview()
                    $0.width.equalTo(width * 1.2)
                    $0.height.equalTo(height * 1.2)
                }
            }
        } else {
            debugPrint("이미지를 찾을 수 없습니다.")
        }
    }
}

final fileprivate class StarrySkyView: UIView {
    private let starCount = 20  // 별 개수 조절
    private let backgroundSize = CGSize(width: 300, height: 300) // 패턴 이미지 크기 설정
    private let colors: [UIColor] = [
        .white,
        UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0),  // 연한 블루
        UIColor(red: 1.0, green: 0.9, blue: 0.7, alpha: 1.0),  // 옅은 오렌지
        UIColor(red: 0.8, green: 0.7, blue: 1.0, alpha: 1.0)   // 연한 퍼플
    ]
    
    func generateStarryBackground() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(backgroundSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        UIColor.starAppBG.setFill()
        context.fill(CGRect(origin: .zero, size: backgroundSize))

        // 별 그리기
        for _ in 0..<starCount {
            let starSize = CGFloat.random(in: 0.8...1.3)
            let x = CGFloat.random(in: 0...backgroundSize.width)
            let y = CGFloat.random(in: 0...backgroundSize.height)
            let randomColor = colors.randomElement() ?? .white // 랜덤 색상 선택

            let starRect = CGRect(x: x, y: y, width: starSize, height: starSize)
            context.setFillColor(randomColor.cgColor)
            context.fillEllipse(in: starRect)
        }
        
        let starryImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return starryImage
    }
}

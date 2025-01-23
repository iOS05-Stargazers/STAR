//
//  GradientApplicable.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-23.
//

import UIKit

protocol GradientApplicable: AnyObject {
    var gradientLayer: CAGradientLayer { get }
    func applyGradient(colors: [UIColor], direction: GradientDirection)
}

enum GradientDirection {
    case horizontal // 수평: 좌 -> 우
    case vertical   // 수직: 상 -> 하
}

extension GradientApplicable where Self: UIView {
    
    func applyGradient(colors: [UIColor], direction: GradientDirection) {
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.colors = colors.map { $0.cgColor }
        
        switch direction {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        if gradientLayer.superlayer == nil {
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func layoutGradientLayer() {
        gradientLayer.frame = self.bounds
    }
}

//
//  GradientButton.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-23.
//

import UIKit

final class GradientButton: UIButton {
    
    enum GradientDirection {
        case horizontal // 수평: 좌 -> 우
        case vertical   // 수직: 상 -> 하
    }
    
    // MARK: - Properties
    
    private let gradientLayer = CAGradientLayer()
    // 그라디언트를 적용할 방향 (기본값: 수평)
    var gradientDirection: GradientDirection = .horizontal
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Methods
    
    func applyGradient(colors: [UIColor]) {
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.colors = colors.map { $0.cgColor }
        
        switch gradientDirection {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

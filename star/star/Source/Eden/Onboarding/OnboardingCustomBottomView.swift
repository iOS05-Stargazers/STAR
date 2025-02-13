//
//  OnboardingCustomBottomView.swift
//  star
//
//  Created by Eden on 2/13/25.
//

import UIKit
import SnapKit
import Then

final class OnboardingCustomBottomView: UIView {
    
    private let gradientLayer = CAGradientLayer().then {
        $0.colors = [
            UIColor.clear.cgColor,
            UIColor(red: 71/255, green: 25/255, blue: 127/255, alpha: 1.0).cgColor,
            UIColor.starAppBG.cgColor
        ]
        $0.locations = [0.0, 0.4, 0.6]
        $0.startPoint = CGPoint(x: 0.5, y: 0.0)
        $0.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

//
//  GradientButton.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-23.
//

import UIKit

class GradientButton: UIButton, GradientApplicable {
    
    let gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutGradientLayer()
    }
}

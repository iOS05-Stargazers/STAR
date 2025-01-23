//
//  GradientView.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-23.
//

import UIKit

final class GradientView: UIView, GradientApplicable {
    
    let gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutGradientLayer()
    }
}

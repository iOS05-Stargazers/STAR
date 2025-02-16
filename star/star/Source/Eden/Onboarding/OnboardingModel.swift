//
//  OnboardingModel.swift
//  star
//
//  Created by Eden on 2/16/25.
//

import UIKit

struct OnboardingModel {
    let highlightElements: [OnboardingHighlightElement] // 강조 요소
    let description: String
}

struct OnboardingHighlightElement {
    let view: [UIView]
    let position: (xMultiplier: CGFloat, yMultiplier: CGFloat)
}

//
//  OnboardingModel.swift
//  star
//
//  Created by Eden on 2/16/25.
//

import UIKit

struct OnboardingModel {
    let highlightElements: [OnboardingHighlightElement]? // 강조 요소
    let description: String
}

struct OnboardingHighlightElement {
    let imageView: UIImageView
    let position: (xMultiplier: CGFloat, yMultiplier: CGFloat)
    let leadingInset: CGFloat   // leading 여백
    let trailingInset: CGFloat  // trailing 여백
    
    init(image: UIImage?, position: (xMultiplier: CGFloat, yMultiplier: CGFloat), leadingInset: CGFloat, trailingInset: CGFloat) {
        self.imageView = UIImageView(image: image)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.position = position
        self.leadingInset = leadingInset
        self.trailingInset = trailingInset
    }
}


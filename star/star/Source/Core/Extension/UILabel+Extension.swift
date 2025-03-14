//
//  UILabel+Extension.swift
//  star
//
//  Created by Eden on 1/26/25.
//

import UIKit.UILabel

extension UILabel {
    /// S T A R 텍스트를 자동으로 강조
    func setStarHighlightedText(fullText: String, font: UIFont, color: UIColor) {
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: fullText.count))
        attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: fullText.count))
        
        if let starRange = fullText.range(of: "S T A R") {
            let nsRange = NSRange(starRange, in: fullText)
            
            if let customFont = UIFont(name: "SEBANGGothicOTFBold", size: font.pointSize) {
                attributedString.addAttribute(.font, value: customFont, range: nsRange)
            }
            attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
        }
        
        self.attributedText = attributedString
    }
}

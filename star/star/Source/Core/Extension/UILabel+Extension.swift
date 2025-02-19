//
//  UILabel+Extension.swift
//  star
//
//  Created by Eden on 1/26/25.
//

import UIKit.UILabel

extension UILabel {
    /// localized된 텍스트를 설정하면서 "STAR"를 "S T A R"로 변환 후 폰트 변경 적용
    func setLocalizedText(_ key: String, font: UIFont, color: UIColor) {
        let localizedText = key.localized
        let transformedText = localizedText.replacingOccurrences(of: "STAR", with: "S T A R")
        let attributedString = NSMutableAttributedString(string: transformedText)
        
        /// 기본 폰트 & 색상 적용
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: transformedText.count))
        attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: transformedText.count))
        
        /// "S T A R" 단어가 포함되어 있다면, 별도 폰트 적용
        if let starRange = transformedText.range(of: "S T A R") {
            let nsRange = NSRange(starRange, in: transformedText)
            
            if let customFont = UIFont(name: "SEBANGGothicOTFBold", size: font.pointSize) {
                attributedString.addAttribute(.font, value: customFont, range: nsRange)
            }
        }
        
        self.attributedText = attributedString
    }
}

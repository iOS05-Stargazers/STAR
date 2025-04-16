//
//  UILabel+Extension.swift
//  star
//
//  Created by Eden on 1/26/25.
//

import UIKit.UILabel

extension UILabel {
    
    func addCharacterSpacing(_ value: CGFloat = -0.03) {
        let kernValue = self.font.pointSize * value
        guard let text = text,
              !text.isEmpty else { return }
        
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern,
                            value: kernValue,
                            range: NSRange(location: 0,
                                           length: string.length - 1))
        
        attributedText = string
    }
    
    func setLogoTitle(_ value: CGFloat) {
        text = "STAR"
        addCharacterSpacing(value)
        textColor = .starButtonWhite
    }
}

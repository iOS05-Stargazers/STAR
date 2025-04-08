//
//  Fonts.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-21.
//

import UIKit.UIFont

extension UIFont {
    // SystemFont
    enum System {
        // size: 12
        static let semibold12 = UIFont.systemFont(ofSize: 12, weight: .semibold)
        // size: 14
        static let semibold14 = UIFont.systemFont(ofSize: 14, weight: .semibold)
        // size: 16
        static let regular16 = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let medium16 = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let semibold16 = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let bold16 = UIFont.systemFont(ofSize: 16, weight: .bold)
        // size: 20
        static let semibold20 = UIFont.systemFont(ofSize: 20, weight: .semibold)
        // size: 22
        static let bold22 = UIFont.systemFont(ofSize: 22, weight: .bold)
        // size: 24
        static let semibold24 = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let bold24 = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    // SebangGothic
    enum SebangGothic {
        // size: 24
        static let bold24 = UIFont(name: "SEBANGGothicOTFBold", size: 24)
    }
    // MonospacedDigitSystem
    enum MonospacedDigitSystem {
        // size: 14
        static let semibold14 = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .semibold)
        // size: 32
        static let regular32 = UIFont.monospacedSystemFont(ofSize: 32, weight: .regular)
        // size: 80
        static let light80 = UIFont.monospacedDigitSystemFont(ofSize: 80, weight: .light)
    }
    
}

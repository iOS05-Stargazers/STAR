//
//  String+Localization.swift
//  star
//
//  Created by Eden on 2/19/25.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "").replacingOccurrences(of: "\\n", with: "\n")
    }
}

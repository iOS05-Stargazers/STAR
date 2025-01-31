//
//  UIStackView+Extension.swift
//  star
//
//  Created by Eden on 1/25/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}

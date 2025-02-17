//
//  UIView+Extension.swift
//  star
//
//  Created by Eden on 1/25/25.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

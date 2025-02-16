//
//  CustomGrabber.swift
//  star
//
//  Created by 안준경 on 2/13/25.
//

import UIKit
import SnapKit

final class CustomGrabberView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        layer.cornerRadius = 3
        
        self.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(6)
        }
    }
}

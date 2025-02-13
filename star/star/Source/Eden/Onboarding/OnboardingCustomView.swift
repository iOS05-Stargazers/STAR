//
//  OnboardingCustomView.swift
//  star
//
//  Created by Eden on 2/13/25.
//

import UIKit
import SnapKit
import Then


final class OnboardingCustomView: UIView {
    
    private let bottomView = OnboardingCustomBottomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        guard let backgroundImage = UIImage(named: "backgroundImage") else { return }
        backgroundColor = UIColor(patternImage: backgroundImage)
        
        addSubviews(bottomView)
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(440)
        }
    }
}



//
//  OnboardingView.swift
//  star
//
//  Created by Eden on 1/24/25.
//

import UIKit
import SnapKit
import Then

class OnboardingView: UIView {
    
    // MARK: - UI Components
    
    let titleLabel = UILabel().then {
        $0.text = "스크린타임 권한을 설정해주세요."
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        guard let backgroundImage = UIImage(named: "backgroundImage") else { return }
        backgroundColor = UIColor(patternImage: backgroundImage)
        
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(125)
            $0.centerX.equalToSuperview()
        }
    }
}

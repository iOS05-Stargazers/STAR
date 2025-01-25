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
    
    let descriptionLabel = UILabel().then {
        $0.text = "STAR가 스크린타임을 분석하기 위해서는\n사용자의 권한 허용이 필요합니다."
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .starSecondaryText
        $0.textAlignment = .center
        $0.numberOfLines = 0
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
        addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(125)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}


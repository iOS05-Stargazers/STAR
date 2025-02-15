//
//  OnboardingCell.swift
//  star
//
//  Created by Eden on 2/15/25.
//

import UIKit
import SnapKit
import Then

final class OnboardingCell: UICollectionViewCell {
    
    static let identifier = "OnboardingCell"
    
    // MARK: - UI Components
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    let titleLabel = UILabel().then {
        $0.text = "당신의 디지털 시간 관리 단위, 스타"
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .starPrimaryText
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
        contentView.addSubviews(
            imageView,
            titleLabel,
            descriptionLabel
        )
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

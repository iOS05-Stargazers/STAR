//
//  PermissionView.swift
//  star
//
//  Created by Eden on 1/24/25.
//

import UIKit
import SnapKit
import Then

final class PermissionView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "permission.title".localized
        $0.font = UIFont.System.bold24
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setStarHighlightedText(
            fullText: "permission.description".localized,
            font: UIFont.System.semibold16,
            color: UIColor.starSecondaryText
        )
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let footerLabel = UILabel().then {
        $0.text = "permission.notice".localized
        $0.font = UIFont.System.semibold16
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
    
    func setupUI() {
        guard let backgroundImage = UIImage(named: "backgroundImage") else { return }
        backgroundColor = UIColor(patternImage: backgroundImage)
        
        addSubviews(
            titleLabel,
            descriptionLabel,
            footerLabel
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(128)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        footerLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-80)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

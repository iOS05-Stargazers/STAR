//
//  OnboardingView.swift
//  star
//
//  Created by Eden on 1/24/25.
//

import UIKit
import SnapKit
import Then

/// PermissionViewReperesentable로 wrapping되어 ContentViewContainer에서 보여집니다.
class PermissionView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "스크린타임 권한을 설정해주세요."
        $0.font = Fonts.permissionTitle
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setStarHighlightedText(
            fullText: "STAR가 정상적으로 작동하기 위해서는\n사용자의 권한 허용이 필요합니다.",
            font: Fonts.permissionBody,
            color: UIColor.starSecondaryText
        )
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let alertHighlightView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.systemBlue.cgColor
        $0.layer.cornerRadius = 20
        $0.isHidden = false
    }
    
    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.up")?.withTintColor(.systemBlue).withRenderingMode(.alwaysOriginal)
        $0.isHidden = false
    }
    
    private let footerLabel = UILabel().then {
        $0.text = "사용자의 정보는 Apple에 의해 보호되며,\n외부로 절대 노출되지 않습니다."
        $0.font = Fonts.permissionBody
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
            alertHighlightView,
            arrowImageView,
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
        
        // TODO: - 레이아웃 정의
        
//        alertHighlightView.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.centerY.equalToSuperview().offset(16)
//            $0.width.equalTo(270 + 28)
//            $0.height.equalTo(195 + 28)
//        }
//        
//        arrowImageView.snp.makeConstraints {
//            $0.top.equalTo(alertHighlightView.snp.bottom).offset(0)
//            $0.centerX.equalToSuperview().offset(-67.5)
//            $0.width.equalTo(24)
//            $0.height.equalTo(40)
//        }
        
        footerLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-80)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

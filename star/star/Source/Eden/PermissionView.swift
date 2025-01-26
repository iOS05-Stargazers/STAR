//
//  OnboardingView.swift
//  star
//
//  Created by Eden on 1/24/25.
//

import UIKit
import SnapKit
import Then

class PermissionView: UIView {
    
    // MARK: - UI Components
    
    let titleLabel = UILabel().then {
        $0.text = "스크린타임 권한을 설정해주세요."
        $0.font = Fonts.permissionTitle
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    let descriptionLabel = UILabel().then {
        $0.setStarHighlightedText(
            fullText: "STAR가 스크린타임을 분석하기 위해서는\n사용자의 권한 허용이 필요합니다.",
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
        $0.layer.cornerRadius = 12
    }
    
    let arrowView = ArrowView().then {
        $0.backgroundColor = .clear
    }
    
    let alertView = UIView().then {
        $0.backgroundColor = .starModalBG
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    let alertTitleLabel = UILabel().then {
        $0.setStarHighlightedText(
            fullText: "'STAR' 앱이 스크린 타임에 접근하려고 함",
            font: UIFont.boldSystemFont(ofSize: 20),
            color: UIColor.starPrimaryText
        )
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let alertMessageLabel = UILabel().then {
        $0.setStarHighlightedText(
            fullText: """
                'STAR'에 스크린 타임 접근을 허용하면,
                이 앱이 사용자의 활동 데이터를 보고,
                콘텐츠를 제한하며, 앱 및 웹사이트의
                사용을 제한할 수도 있습니다.
                """,
            font: Fonts.permissionBody,
            color: UIColor.starSecondaryText
        )
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 0
    }
    
    let dividerTop = UIView().then {
        $0.backgroundColor = .darkGray
    }
    
    let denyButton = UIButton(type: .system).then {
        $0.setTitle("허용 안 함", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = Fonts.permissionBody
    }
    
    let allowButton = UIButton(type: .system).then {
        $0.setTitle("계속", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = Fonts.permissionBody
    }
    
    let verticalDivider = UIView().then {
        $0.backgroundColor = .darkGray
    }
    
    let footerLabel = UILabel().then {
        $0.text = "사용자의 정보는 Apple에 의해 보호되며,\n외부로 절대 노출되지 않습니다."
        $0.font = Fonts.permissionBody
        $0.textColor = .starSecondaryText
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let learnMoreButton = UIButton(type: .system).then {
        $0.setTitle("더 알아보기", for: .normal)
        $0.setTitleColor(.starSecondaryText, for: .normal)
        $0.titleLabel?.font = Fonts.permissionRedirect
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
        
        addSubviews(
            titleLabel,
            descriptionLabel,
            alertHighlightView,
            arrowView,
            footerLabel,
            learnMoreButton
        )
        alertHighlightView.addSubview(alertView)
        alertView.addSubviews(
            dividerTop,
            alertTitleLabel,
            alertMessageLabel,
            buttonStackView
        )
        
        buttonStackView.addArrangedSubviews(
            denyButton, allowButton
        )
        buttonStackView.addSubview(verticalDivider)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(128)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        alertHighlightView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        arrowView.snp.makeConstraints{
            $0.top.equalTo(alertHighlightView.snp.bottom).offset(0)
            $0.centerX.equalTo(allowButton)
            $0.width.equalTo(16)
            $0.height.equalTo(32)
        }
        
        alertView.snp.makeConstraints {
            $0.edges.equalTo(alertHighlightView).inset(12)
        }
        
        alertTitleLabel.snp.makeConstraints {
            $0.top.equalTo(alertView).offset(16)
            $0.leading.trailing.equalTo(alertView).inset(12)
        }
        
        alertMessageLabel.snp.makeConstraints {
            $0.top.equalTo(alertTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(alertView).inset(12)
        }
        
        dividerTop.snp.makeConstraints {
            $0.top.equalTo(alertMessageLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(alertView)
            $0.height.equalTo(0.5)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(dividerTop.snp.bottom)
            $0.leading.trailing.bottom.equalTo(alertView)
            $0.height.equalTo(44)
        }
        
        verticalDivider.snp.makeConstraints {
            $0.width.equalTo(0.5)
            $0.centerX.equalTo(buttonStackView)
            $0.top.bottom.equalTo(buttonStackView)
        }
        
        footerLabel.snp.makeConstraints {
            $0.bottom.equalTo(learnMoreButton.snp.top).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        learnMoreButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }
    }
}

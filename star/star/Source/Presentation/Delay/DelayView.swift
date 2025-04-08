//
//  RestStartView.swift
//  star
//
//  Created by 서문가은 on 2/10/25.
//

import UIKit
import SnapKit
import Then

final class DelayView: UIView {
    
    // MARK: - UI Components
    
    // 타이틀 라벨
    private let titleLabel = UILabel().then {
        $0.text = "delay.title".localized
        $0.font = UIFont.System.semibold24
        $0.textAlignment = .center
        $0.textColor = .starButtonWhite
    }
    
    // 설명 라벨
    private let descriptionLabel = UILabel().then {
        $0.text = "delay.motivation".localized
        $0.numberOfLines = 2
        $0.font = UIFont.System.regular16
        $0.textAlignment = .center
        $0.textColor = .starButtonWhite
    }
    
    // 카운트 테두리 뷰
    private let countView = UIView().then {
        $0.layer.cornerRadius = 180 / 2
        $0.clipsToBounds = true
        $0.layer.borderWidth = 8
        $0.layer.borderColor = UIColor.starButtonYellow.cgColor
    }
    
    // 카운트 라벨
    let countLabel = UILabel().then {
        $0.text = "5"
        $0.font = UIFont.MonospacedDigitSystem.regular32
        $0.textAlignment = .center
        $0.textColor = .starButtonWhite
    }
    
    // 취소 버튼
    let cancelButton = GradientButton(type: .system).then {
        $0.setTitle("delay.cancel_button".localized, for: .normal)
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.titleLabel?.font = UIFont.System.bold16
        $0.backgroundColor = .starDisabledTagBG
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
    }
    
    // MARK: - 초기화
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 레이아웃 설정
    
    private func setupUI() {
        [
            titleLabel,
            descriptionLabel,
            countView,
            cancelButton
        ].forEach {
            addSubviews($0)
        }
        
        countView.addSubview(countLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-12)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-100)
            $0.centerX.equalToSuperview()
        }
        
        countView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            $0.width.height.equalTo(180)
        }
        
        countLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

//
//  OnboardingView.swift
//  star
//
//  Created by 0-jerry on 2/1/25.
//

import UIKit
import SnapKit
import Then

final class OnboardingView: UIView {
    // 스타 셀
    private let starCellView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .starModalBG
    }
    
    // 태그 뷰
    private let tagView = GradientView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .starDisabledTagBG
        $0.clipsToBounds = true
        $0.applyGradient(colors: [.starButtonPurple, .starButtonNavy],
                         direction: .horizontal)
    }
    
    // 태그 라벨
    private let tagLabel = UILabel().then {
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
        $0.font = Fonts.starTag
        $0.text = "진행중"
    }
    
    // 타이틀 라벨
    private let titleLabel = UILabel().then {
        $0.textColor = .starPrimaryText
        $0.textAlignment = .left
        $0.font = Fonts.starTitle
        $0.text = "아침 시작하기"
    }
    
    // 시간 라벨
    private let timeLabel = UILabel().then {
        $0.textColor = .starPrimaryText
        $0.textAlignment = .right
        $0.font = Fonts.starTime
        $0.text = "00:00:00"
    }
    
    // 타이머 이미지
    private let timerImageView = UIImageView().then {
        $0.image = UIImage(systemName: "alarm")
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .starPrimaryText
    }
    
    // 안내 문구 라벨
    private let descriptionLabel = UILabel().then {
        setUpDescriptionLabel($0)
        $0.numberOfLines = 2
        $0.text =
"""
스타는 당신의
디지털 시간 관리 단위입니다.
"""
    }
    
    // 생성하기 설명 라벨
    private let buttonDescriptionLabel = UILabel().then {
        setUpDescriptionLabel($0)
        $0.numberOfLines = 2
        $0.text =
"""
스타 추가하기를 통해 
스타를 생성할 수 있습니다.
"""
    }
    
    // 화살표 이미지 뷰
    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.down")
        $0.tintColor = .starPrimaryText
        $0.contentMode = .scaleAspectFit
    }
    
    // 스타 시작하기 버튼 ( 터치 비활성화 )
    private let startStarButton = GradientButton(type: .system).then {
        $0.setTitle("스타 추가하기", for: .normal)
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.titleLabel?.font = Fonts.buttonTitle
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
        $0.isEnabled = false
        $0.applyGradient(colors: [.starButtonPurple, .starButtonNavy],
                         direction: .horizontal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 레이아웃 설정
    private func configureUI() {
        backgroundColor = .starDisabledTagBG.withAlphaComponent(0.8)
        tagView.addSubview(tagLabel)

        [
            tagView,
            titleLabel,
            timeLabel,
            timerImageView
        ].forEach {
            starCellView.addSubview($0)
        }
        
        [
            starCellView,
            descriptionLabel,
            buttonDescriptionLabel,
            arrowImageView,
            startStarButton
        ].forEach { addSubview($0) }
        
        tagView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.height.equalTo(32)
            $0.width.equalTo(60)
        }
        
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalTo(tagView.snp.leading)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        timerImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(88)
            $0.bottom.equalTo(timeLabel.snp.bottom)
        }
        
        starCellView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(118)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }

        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(starCellView.snp.bottom).offset(30)
        }
        
        buttonDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(startStarButton.snp.top).offset(-60)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(buttonDescriptionLabel.snp.bottom).offset(10)
            $0.bottom.equalTo(startStarButton.snp.top).offset(-10)
            $0.width.equalTo(40)
        }
        startStarButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

extension OnboardingView {
    // 안내문구 라벨 세팅 메서드
    private static func setUpDescriptionLabel(_ label: UILabel) {
        label.font = Fonts.tutorialDescription
        label.textAlignment = .center
        label.textColor = .starPrimaryText
    }
}

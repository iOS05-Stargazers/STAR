//
//  StarListView.swift
//  star
//
//  Created by 서문가은 on 1/22/25.
//

import UIKit
import SnapKit
import Then

final class StarListView: UIView {
    
    // MARK: - UI 컴포넌트
    
    // 로고 및 날짜 보여주는 뷰
    let topView = UIView()
    
    // 로고 이미지
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "logo")
    }
    
    // 로고 타이틀 이미지
    private let logoTitleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "logoText")
    }
    
    // 오늘 날짜 라벨
    let todayDateLabel = UILabel().then {
        $0.text = "2025년 1월 20일 (월)"
        $0.textColor = .starPrimaryText
        $0.textAlignment = .left
        $0.font = Fonts.todayDate
    }
    
    // 휴식 뷰
    private let restView = UIView()
    
    // 휴식 버튼
    let restButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "cup.and.saucer.fill"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.tintColor = .starSecondaryText
    }
    
    // 휴식 라벨
    let restButtonLabel = UILabel().then {
        $0.text = "OFF"
        $0.font = Fonts.buttonDescription
        $0.textColor = .starSecondaryText
    }
    
    // 시작하기 버튼
    let addStarButton = GradientButton(type: .system).then {
        $0.setTitle("스타 추가하기", for: .normal)
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.titleLabel?.font = Fonts.buttonTitle
        $0.backgroundColor = .starDisabledTagBG // 그라디언트가 정상적으로 적용될 시 배경색은 보이지 않음
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
    }
    
    // 스타 리스트 컬렉션뷰
    let starListCollectionView = StarListCollectionView()
    
    // 토스트 메세지 뷰
    let toastMessageView = ToastMessageView()
    
    // 스타 없을 경우 보여지는 라벨
    let noStarLabel = UILabel().then {
        $0.text = "아직 스타가 없습니다.\n스타를 생성해주세요!"
        $0.numberOfLines = 2
        $0.font = Fonts.starTitle
        $0.textColor = .starSecondaryText70
        $0.isHidden = true
    }
    
    // MARK: - 초기화
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 레이아웃 구성
    
    private func setupUI() {
        guard let backgroundImage = UIImage(named: "backgroundImage") else { return }
        backgroundColor = UIColor(patternImage: backgroundImage)
        
        [
            topView,
            starListCollectionView,
            restView,
            noStarLabel,
            toastMessageView,
            addStarButton
        ].forEach { addSubview($0) }
        
        [
            logoImageView,
            logoTitleImageView,
            todayDateLabel
        ].forEach { topView.addSubview($0) }
        
        [
            restButton,
            restButtonLabel
        ].forEach {
            restView.addSubview($0)
        }
        
        topView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(70)
            $0.width.equalTo(300)
        }
        
        logoImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(70)
        }
        
        logoTitleImageView.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing)
            $0.top.equalToSuperview().inset(10)
            $0.height.equalTo(20)
            $0.width.equalTo(100)
        }
        
        todayDateLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing)
            $0.bottom.equalToSuperview().inset(4)
            $0.width.equalTo(200)
        }
        
        starListCollectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(addStarButton.snp.top).offset(-32)
        }
        
        restView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(32)
            $0.bottom.equalTo(todayDateLabel.snp.bottom)
            $0.width.height.equalTo(50)
        }
        
        restButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(restButtonLabel.snp.top).offset(-4)
        }
        
        restButtonLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(todayDateLabel.snp.centerY)
        }
        
        addStarButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        toastMessageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(addStarButton.snp.top).offset(-20)
        }
        
        noStarLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addStarButton.applyGradient(colors: [.starButtonPurple, .starButtonNavy], direction: .horizontal)
    }
}

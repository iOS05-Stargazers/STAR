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
        //        $0.text = "2025년 1월 20일 (월)"
        $0.textColor = .starPrimaryText
        $0.textAlignment = .left
        $0.font = UIFont.System.semibold16
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
        $0.font = UIFont.System.medium16
        $0.textColor = .starSecondaryText
    }
    
    
    // 시작하기 버튼
    let addStarButton = GradientButton(type: .system).then {
        $0.setTitle("star_list.add_star_button".localized, for: .normal)
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.titleLabel?.font = UIFont.System.black16
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
        $0.text = "star_list.empty_message".localized
        $0.numberOfLines = 2
        $0.font = UIFont.System.semibold20
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
        let starrySkyView = StarrySkyView()
        if let backgroundImage = starrySkyView.generateStarryBackground() {
            backgroundColor = UIColor(patternImage: backgroundImage)
        }
        
        // 이미지 넣기
        if let image = UIImage(named: "cloudImage") {
            
            let cloudImageView = UIImageView(image: image)
            
            if let height = cloudImageView.image?.size.height, let width = cloudImageView.image?.size.width {
                cloudImageView.alpha = 0.2 // 투명도 조절
                addSubview(cloudImageView)
                
                cloudImageView.snp.makeConstraints {
                    $0.centerX.centerY.equalToSuperview()
                    $0.width.equalTo(width * 1.2)
                    $0.height.equalTo(height * 1.2)
                }
                
            }
        } else {
            print("이미지를 찾을 수 없습니다.")
        }
        
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

extension StarListView {
    
    final private class StarrySkyView: UIView {
        let starCount = 20  // 별 개수 조절
        let backgroundSize = CGSize(width: 300, height: 300) // 패턴 이미지 크기 설정
        
        let colors: [UIColor] = [
            .white,
            UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0),  // 연한 블루
            UIColor(red: 1.0, green: 0.9, blue: 0.7, alpha: 1.0),  // 옅은 오렌지
            UIColor(red: 0.8, green: 0.7, blue: 1.0, alpha: 1.0)   // 연한 퍼플
        ]
        
        func generateStarryBackground() -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(backgroundSize, false, 0)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            
            UIColor.starAppBG.setFill()
            context.fill(CGRect(origin: .zero, size: backgroundSize))

            // 별 그리기
            for _ in 0..<starCount {
                let starSize = CGFloat.random(in: 0.8...1.3)
                let x = CGFloat.random(in: 0...backgroundSize.width)
                let y = CGFloat.random(in: 0...backgroundSize.height)
                let randomColor = colors.randomElement() ?? .white // 랜덤 색상 선택

                let starRect = CGRect(x: x, y: y, width: starSize, height: starSize)
                context.setFillColor(randomColor.cgColor)
                context.fillEllipse(in: starRect)
            }
            
            let starryImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return starryImage
        }
    }
}

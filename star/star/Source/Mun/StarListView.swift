//
//  StarListView.swift
//  star
//
//  Created by 서문가은 on 1/22/25.
//

import UIKit
import Then
import SnapKit

class StarListView: UIView {
    
    // MARK: - UI 컴포넌트
    
    // 로고 및 날짜 보여주는 뷰
    private let topView = UIView().then { _ in }
    
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
    private let todayDateLabel = UILabel().then {
        $0.text = "2025년 1월 20일 (월)"
        $0.textColor = .colorTitleLabel
        $0.textAlignment = .left
        $0.font = Font.Size16.black
    }
    
    // 스타 리스트 컬렉션뷰
    let starListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.register(StarListCollectionViewCell.self, forCellWithReuseIdentifier: StarListCollectionViewCell.id)
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
            starListCollectionView
        ].forEach {
            addSubview($0)
        }
        
        [
            logoImageView,
            logoTitleImageView,
            todayDateLabel
        ].forEach {
            topView.addSubview($0)
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
            $0.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(200)
        }
        
        starListCollectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(150)
        }
    }
}

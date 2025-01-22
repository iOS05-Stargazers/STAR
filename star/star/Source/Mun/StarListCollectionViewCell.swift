//
//  StarListCollectionViewCell.swift
//  star
//
//  Created by 서문가은 on 1/22/25.
//

import UIKit
import Then
import SnapKit

class StarListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI 컴포넌트
    
    static let id = "StarListCollectionViewCell"
    
    // 태그 뷰
    private let tagView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .colorGradationPurple
    }
    
    // 태그 라벨
    private let tagLabel = UILabel().then {
        $0.text = "진행중"
        $0.textColor = .colorTitleLabel
        $0.textAlignment = .center
        $0.font = Font.Size14.bold
    }
    
    // 타이틀 라벨
    private let titleLabel = UILabel().then {
        $0.text = "아침 시작하기"
        $0.textColor = .colorTitleLabel
        $0.textAlignment = .left
        $0.font = Font.Size22.black
    }
    
    // 시간 라벨
    private let timeLabel = UILabel().then {
        $0.text = "02:00:00"
        $0.textColor = .colorTitleLabel
        $0.textAlignment = .right
        $0.font = Font.Size14.semibold
    }
    
    // 타이머 이미지
    private let timerImageView = UIImageView().then {
        $0.image = UIImage(systemName: "alarm")
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .colorTitleLabel
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
        layer.cornerRadius = 20
        backgroundColor = .colorStarBg
        
        [
            tagView,
            titleLabel,
            timeLabel,
            timerImageView
        ].forEach {
            addSubview($0)
        }

        tagView.addSubview(tagLabel)
        
        tagView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.height.equalTo(30)
            $0.width.equalTo(60)
        }
        
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalTo(tagView.snp.leading)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        timerImageView.snp.makeConstraints {
            $0.trailing.equalTo(timeLabel.snp.leading).offset(-8)
            $0.bottom.equalTo(timeLabel.snp.bottom)
        }
    }
}

//
//  StarDeleteAlertViewController.swift
//  star
//
//  Created by 서문가은 on 1/24/25.
//

import UIKit
import Then
import SnapKit

class StarDeleteAlertViewController: UIViewController {
    
    // MARK: - UI 컴포넌트
    
    // 타이틀 이미지
    private let titleImageView = UIImageView().then {
        $0.image = UIImage(systemName: "trash")
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .starPrimaryText
    }
    
    // 설명 라벨
    private let descriptionLabel = UILabel().then {
        $0.text = """
정말로 삭제하시겠니까?
삭제한 스타는 되돌릴 수 없습니다.
"""
        $0.font = Fonts.blockDescription
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    // 버튼 스택뷰
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    // 취소 버튼
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.backgroundColor = .starPrimaryText
        $0.layer.cornerRadius = 12
    }
    
    // 삭제 버튼
    private let deleteButton = UIButton(type: .system).then {
        $0.setTitle("삭제", for: .normal)
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 12
    }
    

    // MARK: - 생명주기 메서드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - 레이아웃 설정
    
    private func setupUI() {
        [
            titleImageView,
            descriptionLabel,
            cancelButton,
            deleteButton
        ].forEach{ view.addSubview($0) }
        
        titleImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(32)
            $0.width.height.equalTo(32)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleImageView.snp.bottom).offset(16)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(32)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
}

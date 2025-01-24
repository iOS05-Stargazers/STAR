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
    
    // 모달뷰
    private let modalView = UIView().then {
        $0.backgroundColor = .starAppBG
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = false
        $0.alpha = 1
    }
    
    // 타이틀 이미지
    private let titleImageView = UIImageView().then {
        $0.image = UIImage(systemName: "trash")
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .starPrimaryText
    }
    
    // 설명 라벨
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = """
정말로 삭제하시겠습니까?
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
        $0.titleLabel?.font = Fonts.buttonTitle
        $0.backgroundColor = .starDisabledTagBG
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.layer.cornerRadius = 12
    }
    
    // 삭제 버튼
    private let deleteButton = UIButton(type: .system).then {
        $0.setTitle("삭제", for: .normal)
        $0.titleLabel?.font = Fonts.buttonTitle
        $0.backgroundColor = .red
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.layer.cornerRadius = 12
    }
    

    // MARK: - 생명주기 메서드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - 레이아웃 설정
    
    private func setupUI() {
        view.backgroundColor = .starAppBG
        view .addSubview(modalView)
        
        [
            titleImageView,
            descriptionLabel,
            buttonStackView
        ].forEach{ modalView.addSubview($0) }
        
        [
            cancelButton,
            deleteButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
        
        modalView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(36)
            $0.center.equalToSuperview()
        }
        
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
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        deleteButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }
}

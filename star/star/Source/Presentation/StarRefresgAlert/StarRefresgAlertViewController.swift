//
//  StarDeleteAlertViewController.swift
//  star
//
//  Created by 서문가은 on 1/24/25.
//

import UIKit
import Then
import SnapKit

final class StarRefresgAlertViewController: UIViewController {
    
    // MARK: - UI 컴포넌트
            
    // 모달뷰
    private let modalView = UIView().then {
        $0.backgroundColor = .starAlertBG
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = false
        $0.alpha = 1
    }
    
    // 타이틀 이미지
    private let titleImageView = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.clockwise")
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .starPrimaryText
    }
    
    // 설명 라벨
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.text = "refresh.lock_list_updated".localized
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
        $0.font = UIFont.System.medium16
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    // 취소 버튼
    private lazy var confirmButton = UIButton(type: .system).then {
        $0.setTitle("refresh.confirm_button".localized, for: .normal)
        $0.titleLabel?.font = UIFont.System.black16
        $0.backgroundColor = .starDisabledTagBG
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(confirm), for: .touchUpInside)
    }
    
    // MARK: - 레이아웃 설정
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(modalView)
        
        [
            titleImageView,
            descriptionLabel,
            confirmButton
        ].forEach { modalView.addSubview($0) }
        
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
        
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.width.equalTo(100)
            $0.height.equalTo(44)
            
            $0.bottom.equalToSuperview().inset(32)
        }
    }
    
    @objc private func confirm() {
        dismiss(animated: true)
    }
}

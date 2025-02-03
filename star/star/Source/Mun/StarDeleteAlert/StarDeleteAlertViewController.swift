//
//  StarDeleteAlertViewController.swift
//  star
//
//  Created by 서문가은 on 1/24/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class StarDeleteAlertViewController: UIViewController {
    
    // MARK: - UI 컴포넌트
    
    private let viewModel: StarDeleteAlertViewModel
    private let disposeBag = DisposeBag()
    
    // 모달뷰
    private let modalView = UIView().then {
        $0.backgroundColor = .starAlertBG
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
        $0.numberOfLines = 2
        $0.text = """
정말로 삭제하시겠습니까?
삭제한 스타는 되돌릴 수 없습니다.
"""
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
        $0.font = Fonts.buttonDescription
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
        $0.backgroundColor = .starDelete
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.layer.cornerRadius = 12
    }
    
    // MARK: - 생명주기 메서드
    
    init(viewModel: StarDeleteAlertViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    // MARK: - 레이아웃 설정
    
    private func setupUI() {
        view.addSubview(modalView)
        
        [
            titleImageView,
            descriptionLabel,
            buttonStackView
        ].forEach { modalView.addSubview($0) }
        
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

// MARK: - bind

extension StarDeleteAlertViewController {
    
    private func bind() {
        let input = StarDeleteAlertViewModel.Input(
            cancelButtonTapped: cancelButton.rx.tap.asObservable(),
            deleteButtonTapped: deleteButton.rx.tap.asObservable())
        viewModel.transform(input)
        
        // 취소버튼, 삭제버튼 이벤트 처리
        Driver<Void>
            .merge(cancelButton.rx.tap.asDriver(),
                   deleteButton.rx.tap.asDriver())
            .drive(with: self, onNext: { owner, _ in
                owner.closeModal()
            })
            .disposed(by: disposeBag)
    }
    
    // 모달 닫기
    private func closeModal() {
        dismiss(animated: false)
    }
}

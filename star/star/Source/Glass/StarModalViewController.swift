//
//  StarModalViewController.swift
//  star
//
//  Created by t2023-m0072 on 1/22/25.
//

import UIKit
import RxSwift
import RxCocoa
import Then

final class StarModalViewController: UIViewController {
    
    private let starModalView = StarModalView()
//    private let datePickerView = StarModalDatePickerModalView()
//    private let datePickerViewController = StarModalDatePickerModalViewController()
    private let viewModel: StarModalViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: StarModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setup()
        bind()
        setAction()
    }
    
    private func setup() {
        view = starModalView
    }
}

// MARK: - Action

extension StarModalViewController {
    private func setAction() {
        
        // 스타 이름 입력 텍스트필드
        starModalView.nameTextField.rx.text.subscribe(onNext: { data in
            guard let text = data else { return }
            
            // 16자 입력제한
            if text.count > 16 {
                self.starModalView.nameTextField.text = String(text.prefix(16))
            }
        }).disposed(by: disposeBag)
        
        // 앱 잠금 버튼
        starModalView.appLockButton.rx.tap.withUnretained(self).bind { owner, _ in
            print("앱 잠금 버튼 클릭")
        }.disposed(by: disposeBag)
        
        // 요일 버튼 클릭
        starModalView.weekButtons.forEach { button in
            button.rx.tap.subscribe(onNext: {
                button.gradientLayer.isHidden.toggle()
            }).disposed(by: disposeBag)
        }
        
        // 시작시간 DatePicker
//        starModalView.startTimeButton.rx.tap.subscribe(onNext: {
//            self.datePickerViewController.sheetPresentationController?.detents = [.custom(resolver: { _ in
//                return 300
//            })
//            ]
//            self.datePickerViewController.sheetPresentationController?.selectedDetentIdentifier = .medium
//            self.datePickerViewController.modalPresentationStyle = .popover
//            self.present(self.datePickerViewController, animated: true)
//        }).disposed(by: disposeBag)
        
        // 텍스트필드 외부 탭 했을때 키보드 내리기
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind { [weak self] _ in
            self?.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        // 키보드 return키 입력시 키보드 내리기
        starModalView.nameTextField.rx.controlEvent(.editingDidEndOnExit).bind { [weak self] in
            self?.starModalView.nameTextField.resignFirstResponder()
        }.disposed(by: disposeBag)
        
        starModalView.addStarButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.closeModal()
            })
            .disposed(by: disposeBag)
    }
    
    private func closeModal() {
        dismiss(animated: true)
    }
}

// MARK: - ViewModel Bind

extension StarModalViewController {
    
    private func bind() {
        
        let name = starModalView.nameTextField.rx.text.orEmpty.asObservable()
        let startTime = starModalView.startTimeButton.rx.title(for: .normal).asObserver()
        let endTime = starModalView.endTimeButton.rx.title(for: .normal).asObserver()
        let addStarButtonTap = starModalView.addStarButton.rx.tap.asObservable()
        
        let input = StarModalViewModel.Input(nameTextFieldInput: name, startTimePick: startTime, endTimePick: endTime, addStarTap: addStarButtonTap)
        
        let output = viewModel.transform(input: input)
        
        output.result.drive().disposed(by: disposeBag)
        output.star
            .drive(with: self, onNext: { owner, star in
                guard let star = star else { return }
                owner.starModalView.configure(star: star)
            })
            .disposed(by: disposeBag)
    }
}

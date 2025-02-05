//
//  StarModalViewController.swift
//  star
//
//  Created by t2023-m0072 on 1/22/25.
//

import UIKit
import SwiftUI
import FamilyControls
import RxSwift
import RxCocoa
import Then

final class StarModalViewController: UIViewController {
    
    private let starModalView = StarModalView()
//    private let datePickerView = StarModalDatePickerModalView()
//    private let datePickerViewController = StarModalDatePickerModalViewController()
    private let viewModel: StarModalViewModel
    private let disposeBag = DisposeBag()
    
    private var familyActivitySelection = FamilyActivitySelection()
    private var isFamilyActivityPickerPresented = false
    
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
        
//        starModalView.appLockButton.rx.tap.withUnretained(self)
//            .subscribe(onNext: { owner, _ in
//                owner.appPicker()
//            }).disposed(by: disposeBag)
        
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
    }
}

// MARK: - ViewModel Bind

extension StarModalViewController {
    
    private func bind() {
        
        let name = starModalView.nameTextField.rx.text.orEmpty.asObservable()
        let appLockButtonTap = starModalView.appLockButton.rx.tap.asObservable()
        let startTime = starModalView.startTimeButton.rx.title(for: .normal).asObserver()
        let endTime = starModalView.endTimeButton.rx.title(for: .normal).asObserver()
        let addStarButtonTap = starModalView.addStarButton.rx.tap.asObservable()
        
        let input = StarModalViewModel.Input(nameTextFieldInput: name,
                                             appLockButtonTap: appLockButtonTap,
                                             startTimePick: startTime,
                                             endTimePick: endTime,
                                             addStarTap: addStarButtonTap)
        
        let output = viewModel.transform(input: input)
        
        output.result.drive().disposed(by: disposeBag)
        
        // 스타 바인딩(edit 모드일 때 방출)
        output.star
            .drive(with: self, onNext: { owner, star in
                guard let star = star else { return }
                owner.starModalView.configure(star: star)
            })
            .disposed(by: disposeBag)
        
        // 입력값 에러 바인딩
        output.starModalInputState
            .drive(with: self, onNext: { owner, error in
                owner.showToastMessage(error.text)
            })
            .disposed(by: disposeBag)
        
        // refresh 바인딩(모달 종료, 스타 메인 화면 데이터 fetch)
        output.refresh
            .drive(with: self, onNext: { owner, error in
                owner.closeModal()
            })
            .disposed(by: disposeBag)
        
        output.familyControlsPicker
            .drive(onNext: { [weak self] in
                self?.appPicker()
            })
            .disposed(by: disposeBag)
    }
    
    // 토스트 메세지 띄우기
    private func showToastMessage(_ message: String) {
        UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseIn, animations: {
            self.starModalView.toastView.isHidden = false
            self.starModalView.toastView.alpha = 0.0
            self.starModalView.toastLable.text = message
        }) { _ in
            self.starModalView.toastView.isHidden = true
            self.starModalView.toastView.alpha = 1
        }
    }
    
    // 모달 종료
    private func closeModal() {
        dismiss(animated: true)
    }
    
//    @objc
    private func appPicker() {
        let isPresentedBinding = Binding<Bool>(
            get: { self.isFamilyActivityPickerPresented },
            set: { newValue in
                self.isFamilyActivityPickerPresented = newValue
                // picker가 닫힐 때(newValue가 false) 필요한 작업을 추가할 수 있습니다.
            }
        )
        
        let selectionBinding = Binding<FamilyActivitySelection>(
            get: { self.familyActivitySelection },
            set: { newSelection in
                self.familyActivitySelection = newSelection
                // 선택 결과를 viewModel이나 다른 곳에 전달할 수 있음
                               print("선택된 Family Activity: \(newSelection)")
            }
        )
        
        let pickerView = FamilyActivityPickerWrapper(isPresented: isPresentedBinding, selection: selectionBinding)
        
        let hostingVC = UIHostingController(rootView: pickerView)
        hostingVC.modalPresentationStyle = .formSheet
        
        self.isFamilyActivityPickerPresented = true
        self.present(hostingVC, animated: true, completion: nil)
    }
}

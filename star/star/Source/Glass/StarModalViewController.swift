//
//  StarModalViewController.swift
//  star
//
//  Created by t2023-m0072 on 1/22/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Then

class StarModalViewController: UIViewController {
    
    private let modal = StarModalView()
    private let viewModel = StarModalViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        setup()
        bind()
        setAction()
    }
    
    private func setup() {
        view = modal
    }
}

// MARK: - 내장 키보드 동작 제어

extension StarModalViewController: UITextFieldDelegate {
    // 텍스트필드 외부 탭 했을때 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // return키 입력시 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - ViewModel Bind

extension StarModalViewController {
    
    private func bind() {
        
    }
}

// MARK: - Action

extension StarModalViewController {
    private func setAction() {
        
        // 스타 이름 입력 텍스트필드
        modal.nameTextField.rx.text.subscribe(onNext: { data in
            guard let text = data else { return }
            
            // 16자 입력제한
            if text.count > 16 {
                self.modal.nameTextField.text = String(text.prefix(16))
            }
        }).disposed(by: disposeBag)
        
        // 앱 잠금 버튼
        modal.appLockButton.rx.tap.withUnretained(self).bind { owner, _ in
            print("앱 잠금 버튼 클릭")
        }.disposed(by: disposeBag)
        
        // 요일 버튼 클릭
        modal.weekButtons.forEach { button in
            button.rx.tap.subscribe(onNext: {
                // tag : 0 -> 클릭(X), 1 -> 클릭(O)
                let tappedCheck = button.tag
                
                if tappedCheck == 0 {// 버튼 비활성화 상태일 때 탭한 경우
                    button.applyGradient(colors: [.starButtonPurple, .starButtonNavy], direction: .horizontal)
                    button.tag = 1
                } else {// 버튼 활성화 상태일 때 탭한 경우
                    button.applyGradient(colors: [.starDisabledTagBG], direction: .horizontal)
                    button.tag = 0
                }
            }).disposed(by: disposeBag)
        }
        
        // 시작 시간 DataPicker 모달
        
        // 종료 시간 DataPicker 모달
        
    }
}

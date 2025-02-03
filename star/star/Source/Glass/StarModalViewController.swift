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
    private let viewModel = StarModalViewModel()
    private let disposeBag = DisposeBag()

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
        starModalView.nameTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] in
                self?.starModalView.nameTextField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - ViewModel Bind
extension StarModalViewController {
    
    private func bind() {
        let name = starModalView.nameTextField.rx.text.orEmpty.asObservable()
        
        let startTime = starModalView.startTimeButton.rx.tap
            .map { [weak starModalView] in
                starModalView?.startTimeButton.title(for: .normal)
            }
            .startWith(starModalView.startTimeButton.title(for: .normal))
        
        let endTime = starModalView.endTimeButton.rx.tap
            .map { [weak starModalView] in
                starModalView?.endTimeButton.title(for: .normal)
            }
            .startWith(starModalView.endTimeButton.title(for: .normal))
        
        let appLockButtonTap = starModalView.appLockButton.rx.tap.asObservable()
        
        let addStarButtonTap = starModalView.addStarButton.rx.tap.asObservable()
        
        let weekButtonsTap: Observable<WeekDay> = Observable.merge(
            starModalView.mondayButton.rx.tap.map { WeekDay.mon },
            starModalView.tuesdayButton.rx.tap.map { WeekDay.tue },
            starModalView.wednesdayButton.rx.tap.map { WeekDay.wed },
            starModalView.thursdayButton.rx.tap.map { WeekDay.thu },
            starModalView.fridayButton.rx.tap.map { WeekDay.fri },
            starModalView.saturdayButton.rx.tap.map { WeekDay.sat },
            starModalView.sundayButton.rx.tap.map { WeekDay.sun }
        )
        
        let input = StarModalViewModel.Input(nameTextFieldInput: name,
                                             startTimePick: startTime,
                                             endTimePick: endTime,
                                             appLockButtonTap: appLockButtonTap,
                                             weekButtonsTap: weekButtonsTap,
                                             addStarTap: addStarButtonTap)
        
        let output = viewModel.transform(input: input)
        
        output.result.drive().disposed(by: disposeBag)
        output.showFamilyActivityPicker.drive(onNext: { [weak self] in
            guard let self = self else { return }
            let pickerVC = FamilyControlsPickerVC()
            pickerVC.modalPresentationStyle = .formSheet
            self.present(pickerVC, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}

//
//  StarModalViewController.swift
//  star
//
//  Created by 안준경 on 1/22/25.
//

import UIKit
import SwiftUI
import FamilyControls
import RxSwift
import RxCocoa
import Then

enum TimeType {
    case startTime(starTime: StarTime)
    case endTime(starTime: StarTime)
}

final class StarModalViewController: UIViewController {
    
    private let starModalView = StarModalView()
    private let viewModel: StarModalViewModel
    
    let startTimeRelay = PublishRelay<StarTime>()
    let endTimeRelay = PublishRelay<StarTime>()
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
        view = starModalView
        bind()
        setModalAction()
    }
}

// MARK: - Action

extension StarModalViewController {
    private func setModalAction() {
        
        // 스타 이름 입력 텍스트필드
        starModalView.nameTextField.rx.text
            .subscribe(onNext: { data in
                guard let text = data else { return }
                
                // 16자 입력제한
                if text.count > 16 {
                    self.starModalView.nameTextField.text = String(text.prefix(16))
                }
            }).disposed(by: disposeBag)
        
        // 텍스트필드 클리어버튼
        starModalView.clearButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.starModalView.nameTextField.text = ""
            }).disposed(by: disposeBag)
        
        // 앱 잠금 버튼
        starModalView.appLockButton.rx.tap.withUnretained(self).bind { owner, _ in
            print("앱 잠금 버튼 클릭")
            self.appPicker()
        }.disposed(by: disposeBag)
        
        // 텍스트필드 외부 탭 했을때 키보드 내리기
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind { [weak self] _ in
            self?.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        // 키보드 return키 입력시 키보드 내리기
        starModalView.nameTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .bind { [weak self] in
                self?.starModalView.nameTextField.resignFirstResponder()
            }.disposed(by: disposeBag)
        
        // 시작시간 버튼 탭
        starModalView.startTimeButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                guard let startTime = owner.starModalView.startTimeButton.titleLabel?.text else { return }
                let starTime = StarTime(from: startTime)
                owner.connectPickerModal(mode: .startTime(starTime: starTime))
            }).disposed(by: disposeBag)
        
        // 종료시간 버튼 탭
        starModalView.endTimeButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                guard let endTime = owner.starModalView.endTimeButton.titleLabel?.text else { return }
                let starTime = StarTime(from: endTime)
                owner.connectPickerModal(mode: .endTime(starTime: starTime))
            }).disposed(by: disposeBag)
    }
    
    // 날짜 포맷 변환
    private func dateToString(date: Date) -> String{
        let dateFormetter = DateFormatter()
        dateFormetter.dateFormat = "HH:mm"
        
        return dateFormetter.string(from: date)
    }
    
    // 모달창 연결
    private func connectPickerModal(mode: TimeType) {
        let pickerViewModel = PickerModalViewModel(mode: mode,
                                                   startTimeRelay: startTimeRelay,
                                                   endTimeRelay: endTimeRelay)
        let pickerModalViewController = PickerModalViewController(viewModel: pickerViewModel)
        pickerModalViewController.modalPresentationStyle = .pageSheet
        
        // 모달 화면 높이 설정
        if let sheet = pickerModalViewController.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom { _ in
                        return 400
                    }
                ]
            } else {
                sheet.detents = [.medium()]
            }
        }
        
        pickerModalViewController.view.layer.cornerRadius = 40
        present(pickerModalViewController, animated: true)
    }
}

// MARK: - ViewModel Bind

extension StarModalViewController {
    
    private func bind() {
        
        // 텍스트 필드
        let name = starModalView.nameTextField.rx.text.orEmpty.skip(1).asObservable()
        let nameClear = starModalView.clearButton.rx.tap.asObservable()
        
        // 요일 버튼
        let weekDaysState = Observable.merge(
            starModalView.mondayButton.buttonState.asObservable(),
            starModalView.tuesdayButton.buttonState.asObservable(),
            starModalView.wednesdayButton.buttonState.asObservable(),
            starModalView.thursdayButton.buttonState.asObservable(),
            starModalView.fridayButton.buttonState.asObservable(),
            starModalView.saturdayButton.buttonState.asObservable(),
            starModalView.sundayButton.buttonState.asObservable()
        )
                
        // 시작시간/종료시간
        // 시작시간 타이틀 바인딩
        startTimeRelay.withUnretained(self).subscribe(onNext: { owner, starTime in
            let text = StarTimeFormatter.convert(starTime)
            owner.starModalView.startTimeButton.setTitle(text, for: .normal)
        }).disposed(by: disposeBag)
        
        // 종료시간 타이틀 바인딩
        endTimeRelay.withUnretained(self).subscribe(onNext: { owner, starTime in
            let text = StarTimeFormatter.convert(starTime)
            owner.starModalView.endTimeButton.setTitle(text, for: .normal)
        }).disposed(by: disposeBag)
        
        // 스타 생성하기 버튼
        let addStarButtonTap = starModalView.addStarButton.rx.tap.asObservable()
        
        let input = StarModalViewModel.Input(nameTextFieldInput: name,
                                             nameClear: nameClear,
                                             addStarTap: addStarButtonTap,
                                             weekDaysState: weekDaysState,
                                             startTimeRelay: startTimeRelay.asObservable(),
                                             endTimeRelay: endTimeRelay.asObservable())
        
        let output = viewModel.transform(input: input)
        
        // 스타 바인딩(edit 모드일 때 방출)
        output.star
            .drive(with: self, onNext: { owner, star in
                guard let star = star else { return }
                owner.starModalView.configure(star: star)
                owner.familyActivitySelection = star.blockList
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
        
        output.weekDaysRelay
            .drive(with: self, onNext: { owner, weekDays in
                weekDays.forEach { weekDay in
                    owner.starModalView.weekButtons.forEach { button in
                        if button.weekDay == weekDay {
                            button.setState(true)
                        }
                    }
                }
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
}

// SwiftUI와 FamilyControls를 이용
extension StarModalViewController {
    private func appPicker() {
        // MARK: - UIKit 기반인 ViewController에서 SwiftUI 기반의 View를 불러오기 위한 임시 변수
        let tempIsPresentedBinding = Binding<Bool>(
            get: { self.isFamilyActivityPickerPresented },
            set: { self.isFamilyActivityPickerPresented = $0 }
        )
        
        let tempSelectionBinding = Binding<FamilyActivitySelection>(
            get: { self.familyActivitySelection },
            set: { self.familyActivitySelection = $0 }
        )
        
        let hostingVC = UIHostingController(
            rootView: FamilyActivityPickerWrapper(isPresented: tempIsPresentedBinding,
                                                  selection: tempSelectionBinding)
        )
        
        // MARK: - hostingVC 설정 갱신을 통해 실제 구현
        
        hostingVC.modalPresentationStyle = .overFullScreen
        hostingVC.view.backgroundColor = .clear
        
        let isPresentedBinding = Binding<Bool>(
            get: { self.isFamilyActivityPickerPresented },
            set: { newValue in
                self.isFamilyActivityPickerPresented = newValue
                // picker가 닫힐 때(newValue가 false) 필요한 작업을 추가할 수 있음
                hostingVC.dismiss(animated: true)
            }
        )
        
        let selectionBinding = Binding<FamilyActivitySelection>(
            get: { self.familyActivitySelection },
            set: { newSelection in
                self.familyActivitySelection = newSelection
                // 선택 결과를 viewModel이나 다른 곳에 전달할 수 있음
                print("선택된 Family Activity: \(newSelection)")
                self.viewModel.familyActivitySelection = newSelection
                hostingVC.dismiss(animated: true)
            }
        )
        
        let pickerView = FamilyActivityPickerWrapper(isPresented: isPresentedBinding, selection: selectionBinding)
        hostingVC.rootView = pickerView
        
        self.isFamilyActivityPickerPresented = true
        self.present(hostingVC, animated: true, completion: nil)
    }
}

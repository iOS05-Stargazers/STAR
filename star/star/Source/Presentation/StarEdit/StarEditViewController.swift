//
//  StarEditViewController.swift
//  star
//
//  Created by 안준경 on 1/22/25.
//

import UIKit
import SwiftUI
import FamilyControls
import RxSwift
import RxCocoa

enum TimeType {
    
    case startTime(starTime: StarTime)
    case endTime(starTime: StarTime)
    
    var text: String {
        switch self {
        case .startTime:
            return "star_edit.start_time".localized
        case .endTime:
            return "star_edit.end_time".localized
        }
    }
    
    var starTime: StarTime {
        switch self {
        case .startTime(let starTime), .endTime(let starTime):
            return starTime
        }
    }
}

final class StarEditViewController: UIViewController {
    
    private let starEditView = StarEditView()
    private let viewModel: StarEditViewModel
    
    let startTimeRelay = PublishRelay<StarTime>()
    let endTimeRelay = PublishRelay<StarTime>()
    private let disposeBag = DisposeBag()
    
    private var familyActivitySelection = FamilyActivitySelection()
    private var isFamilyActivityPickerPresented = false
    
    init(viewModel: StarEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = starEditView
        bind()
        setModalAction()
    }
}

// MARK: - Action

extension StarEditViewController {
    
    private func setModalAction() {
        // 스타 이름 입력 텍스트필드
        starEditView.nameTextField.rx.text
            .withUnretained(self)
            .subscribe(onNext: { onwer, data in
                guard let text = data else { return }
                // 16자 입력제한
                if text.count > 16 {
                    onwer.starEditView.nameTextField.text = String(text.prefix(16))
                }
            }).disposed(by: disposeBag)
        
        // 텍스트필드 클리어버튼
        starEditView.clearButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.starEditView.nameTextField.text = ""
            }).disposed(by: disposeBag)
        
        // 텍스트필드를 입력하면 placeholder 삭제
        starEditView.nameTextField.rx
            .controlEvent(.editingDidBegin)
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.starEditView.nameTextField.placeholder = ""
            }).disposed(by: disposeBag)
        
        // 텍스트필드 입력이 끝나면 placeholder 복구
        starEditView.nameTextField.rx
            .controlEvent(.editingDidEnd)
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.starEditView.nameTextField.placeholder = "star_edit.placeholder_name".localized
            }).disposed(by: disposeBag)
        
        // 앱 잠금 버튼
        starEditView.appLockButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.appPicker()
            }.disposed(by: disposeBag)
        
        // 텍스트필드 외부 탭 했을때 키보드 내리기
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind { [weak self] _ in
                self?.view.endEditing(true)
            }.disposed(by: disposeBag)
        
        // 키보드 return키 입력시 키보드 내리기
        starEditView.nameTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .bind { owner, _ in
                owner.starEditView.nameTextField.resignFirstResponder()
            }.disposed(by: disposeBag)
        
        // 시작시간 버튼 탭
        starEditView.startTimeButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                guard let startTime = owner.starEditView.startTimeButton.titleLabel?.text else { return }
                let starTime = StarTime(from: startTime)
                owner.connectPickerModal(mode: .startTime(starTime: starTime))
            }).disposed(by: disposeBag)
        
        // 종료시간 버튼 탭
        starEditView.endTimeButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                guard let endTime = owner.starEditView.endTimeButton.titleLabel?.text else { return }
                let starTime = StarTime(from: endTime)
                owner.connectPickerModal(mode: .endTime(starTime: starTime))
            }).disposed(by: disposeBag)
    }
    
    // 모달창 연결
    private func connectPickerModal(mode: TimeType) {
        let pickerViewModel = TimePickerModalViewModel(mode: mode,
                                                       startTimeRelay: startTimeRelay,
                                                       endTimeRelay: endTimeRelay)
        let pickerModalViewController = TimePickerModalViewController(viewModel: pickerViewModel)
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

extension StarEditViewController {
    
    private func bind() {
        // 텍스트 필드
        let name = starEditView.nameTextField.rx.text.orEmpty.skip(1).asObservable()
        let nameClear = starEditView.clearButton.rx.tap.asObservable()
        
        // 요일 버튼
        let weekDaysState = Observable.merge(
            starEditView.mondayButton.buttonState.asObservable(),
            starEditView.tuesdayButton.buttonState.asObservable(),
            starEditView.wednesdayButton.buttonState.asObservable(),
            starEditView.thursdayButton.buttonState.asObservable(),
            starEditView.fridayButton.buttonState.asObservable(),
            starEditView.saturdayButton.buttonState.asObservable(),
            starEditView.sundayButton.buttonState.asObservable()
        )
        
        // 시작시간/종료시간
        // 시작시간 타이틀 바인딩
        startTimeRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, starTime in
                let text = StarTimeFormatter.convert(starTime)
                owner.starEditView.startTimeButton.setTitle(text, for: .normal)
            }).disposed(by: disposeBag)
        
        // 종료시간 타이틀 바인딩
        endTimeRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, starTime in
                let text = StarTimeFormatter.convert(starTime)
                owner.starEditView.endTimeButton.setTitle(text, for: .normal)
            }).disposed(by: disposeBag)
        
        // 스타 생성하기 버튼
        let addStarButtonTap = starEditView.addStarButton.rx.tap.asObservable()
        
        let input = StarEditViewModel.Input(nameTextFieldInput: name,
                                            nameClear: nameClear,
                                            weekDaysState: weekDaysState,
                                            addStarTap: addStarButtonTap,
                                            startTimeRelay: startTimeRelay.asObservable(),
                                            endTimeRelay: endTimeRelay.asObservable())
        
        let output = viewModel.transform(input: input)
        
        // 스타 바인딩(edit 모드일 때 방출)
        output.star
            .drive(with: self, onNext: { owner, star in
                guard let star else { return }
                owner.starEditView.configure(star: star)
                owner.familyActivitySelection = star.blockList
            })
            .disposed(by: disposeBag)
        
        // 입력값 에러 바인딩
        output.starModalInputState
            .drive(with: self, onNext: { owner, error in
                owner.starEditView.toastMessageView.showToastMessage(error.text)
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
                    owner.starEditView.weekButtons.forEach { button in
                        if button.weekDay == weekDay {
                            button.setState(true)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.blockList
            .drive(with: self, onNext: { owner, blockList in
                var text = ""
                guard let blockList = blockList else { return }

                if blockList.categories.count == 13 {
                    text = "star_edit.select.all".localized
                } else if blockList.isEmpty {
                    text = "star_edit.select".localized
                } else {
                    text = String(
                        format: "star_edit.select.some".localized,
                        blockList.categories.count,
                        blockList.applications.count,
                        blockList.webDomains.count
                    )
                }
                owner.starEditView.appLockButton.setTitle(text, for: .normal)

                
            })
            .disposed(by: disposeBag)
    }
    
    // 모달 종료
    private func closeModal() {
        dismiss(animated: true)
    }
}

// SwiftUI와 FamilyControls를 이용
extension StarEditViewController {
    
    private func appPicker() {
        // UIKit 기반인 ViewController에서 SwiftUI 기반의 View를 불러오기 위한 임시 변수
        let tempIsPresentedBinding = Binding<Bool>(
            get: { [weak self] in self?.isFamilyActivityPickerPresented ?? .init() },
            set: { [weak self] in self?.isFamilyActivityPickerPresented = $0 }
        )
        
        let tempSelectionBinding = Binding<FamilyActivitySelection>(
            get: { [weak self] in self?.familyActivitySelection ?? .init() },
            set: { [weak self] in self?.familyActivitySelection = $0 }
        )
        
        let hostingVC = UIHostingController(
            rootView: FamilyActivityPickerWrapper(isPresented: tempIsPresentedBinding,
                                                  selection: tempSelectionBinding)
        )
        
        // hostingVC 설정 갱신을 통해 실제 구현
        hostingVC.modalPresentationStyle = .overFullScreen
        hostingVC.view.backgroundColor = .clear
        
        let isPresentedBinding = Binding<Bool>(
            get: { [weak self] in self?.isFamilyActivityPickerPresented ?? .init() },
            set: {  [weak self] newValue in
                self?.isFamilyActivityPickerPresented = newValue
                // picker가 닫힐 때(newValue가 false) 필요한 작업을 추가할 수 있음
                hostingVC.dismiss(animated: true)
            }
        )
        
        let selectionBinding = Binding<FamilyActivitySelection>(
            get: { [weak self] in self?.familyActivitySelection ?? .init() },
            set: { [weak self] newSelection in
                self?.familyActivitySelection = newSelection
                self?.viewModel.blockListRelay.accept(newSelection)
                print("ddddd", newSelection)
                hostingVC.dismiss(animated: true)
            }
        )
        
        let pickerView = FamilyActivityPickerWrapper(isPresented: isPresentedBinding, selection: selectionBinding)
        hostingVC.rootView = pickerView
        
        self.isFamilyActivityPickerPresented = true
        self.present(hostingVC, animated: true, completion: nil)
    }
}
// 스크린 타임 -> 접근 허용 토스트메세지

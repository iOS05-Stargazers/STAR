//
//  StarModalViewController.swift
//  star
//
//  Created by 안준경 on 1/22/25.
//

import UIKit
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
        setModalAction()
        setDatePickerAction()
    }
    
    private func setup() {
        view = starModalView
    }
}

// MARK: - Action

extension StarModalViewController {
    private func setModalAction() {
        
        // 스타 이름 입력 텍스트필드
        starModalView.nameTextField.rx.text.subscribe(onNext: { data in
            guard let text = data else { return }
            
            // 16자 입력제한
            if text.count > 16 {
                self.starModalView.nameTextField.text = String(text.prefix(16))
            }
        }).disposed(by: disposeBag)
        
        // 텍스트필드 클리어버튼
        starModalView.clearButton.rx.tap.withUnretained(self).subscribe(onNext: { owner, _ in
            owner.starModalView.nameTextField.text = ""
        }).disposed(by: disposeBag)
        
        // 앱 잠금 버튼
        starModalView.appLockButton.rx.tap.withUnretained(self).bind { owner, _ in
            print("앱 잠금 버튼 클릭")
        }.disposed(by: disposeBag)
        
        // 요일 버튼 클릭
//        starModalView.weekButtons.forEach { button in
//            button.rx.tap.subscribe(onNext: {
//                button.gradientLayer.isHidden.toggle()
//            }).disposed(by: disposeBag)
//        }
        
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
    
    private func setDatePickerAction() {
        // 시작/종료 시간 버튼 탭
        Observable.merge(
            starModalView.startTimeButton.rx.tap.map { "시작 시간" },
            starModalView.endTimeButton.rx.tap.map { "종료 시간" }
        ).withUnretained(self).subscribe(onNext: { owner, msg in
            owner.starModalView.toolbarTitle.text = msg // toolbar 타이틀 설정
            owner.starModalView.hiddenTextField.becomeFirstResponder() // datePicker 열기
        }).disposed(by: disposeBag)
        
        // 선택 버튼 탭
        starModalView.selectButton.rx.tap.withUnretained(self).subscribe(onNext: { owner, _ in
            let selectTime = owner.dateToString(date: owner.starModalView.datePicker.date)
            
            // 버튼에 시간 표시
            if owner.starModalView.toolbarTitle.text == "시작 시간" {
                owner.starModalView.startTimeButton.setTitle(selectTime, for: .normal)
                
            } else {
                owner.starModalView.endTimeButton.setTitle(selectTime, for: .normal)
            }
            
            owner.starModalView.hiddenTextField.resignFirstResponder() // datePicker 닫기
        }).disposed(by: disposeBag)
        
        // 취소 버튼 탭
        starModalView.cancelButton.rx.tap.subscribe(onNext: {
            self.starModalView.hiddenTextField.resignFirstResponder() // datePicker 닫기
        }).disposed(by: disposeBag)
        
    }
    
    // 날짜 포맷 변환
    private func dateToString(date: Date) -> String{
        let dateFormetter = DateFormatter()
        dateFormetter.dateFormat = "HH:mm"
        
        return dateFormetter.string(from: date)
    }
}

// MARK: - ViewModel Bind

extension StarModalViewController {
    
    private func bind() {
        
        // 텍스트 필드
        let name = starModalView.nameTextField.rx.text.orEmpty.asObservable()
        let nameClear = starModalView.clearButton.rx.tap.asObservable()
        
        // 요일 버튼
        let mondayTapped = starModalView.mondayButton.rx.tap.asObservable()
        let tuesdayTapped = starModalView.tuesdayButton.rx.tap.asObservable()
        let wednesdayTapped = starModalView.wednesdayButton.rx.tap.asObservable()
        let thursdayTapped = starModalView.thursdayButton.rx.tap.asObservable()
        let fridayTapped = starModalView.fridayButton.rx.tap.asObservable()
        let saturdayTapped = starModalView.saturdayButton.rx.tap.asObservable()
        let sundayTapped = starModalView.sundayButton.rx.tap.asObservable()
        
        let startTimeSubject = PublishSubject<Date>()
        let endTimeSubject = PublishSubject<Date>()
        
        
        // DatePicker
        starModalView.selectButton.rx.tap.withUnretained(self).subscribe(onNext: { owner, _ in
            
            // 시작 시간
            if (owner.starModalView.startTimeButton.titleLabel?.text) != nil {
                owner.starModalView.datePicker.rx.date.bind(to: startTimeSubject).disposed(by: owner.disposeBag)
            }
            
            // 종료 시간
            if (owner.starModalView.endTimeButton.titleLabel?.text) != nil {
                owner.starModalView.datePicker.rx.date.bind(to: endTimeSubject).disposed(by: owner.disposeBag)
            }
        }).disposed(by: disposeBag)

        // 스타 생성하기 버튼
        let addStarButtonTap = starModalView.addStarButton.rx.tap.asObservable()
        
        let input = StarModalViewModel.Input(nameTextFieldInput: name,
                                             nameClear: nameClear,
                                             mondayTapped: mondayTapped,
                                             tuesdayTapped: tuesdayTapped,
                                             wednesdayTapped: wednesdayTapped,
                                             thursdayTapped: thursdayTapped,
                                             fridayTapped: fridayTapped,
                                             saturdayTapped: saturdayTapped,
                                             sundayTapped: sundayTapped,
                                             startTimeSubject: startTimeSubject.asObservable(),
                                             endTimeSubject: endTimeSubject.asObservable(),
                                             addStarTap: addStarButtonTap)
        
        let output = viewModel.transform(input: input)
                
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

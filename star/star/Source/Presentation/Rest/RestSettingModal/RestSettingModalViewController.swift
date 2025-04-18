//
//  RestSettingModalViewController.swift
//  star
//
//  Created by 안준경 on 2/10/25.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class RestSettingModalViewController: UIViewController {
    
    private let restSettingCompleteRelay: PublishRelay<Date>
    private let disposeBag = DisposeBag()
    
    // picker 데이터
    private let pickerData = Observable.just(Array<Int>(1...20))
    
    private let titleLabel = UILabel().then {
        $0.text = "break_mode.title".localized
        $0.font = UIFont.System.semibold24
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    private let textLabel = UILabel().then {
        $0.text = "break_mode.description".localized
        $0.font = UIFont.System.regular16
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    private let pickerView = UIPickerView().then {
        $0.backgroundColor = .clear
        $0.setValue(UIColor.starPrimaryText, forKey: "textColor")
    }
    
    private let pickerLabel = UILabel().then {
        $0.text = "break_mode.unit_minute".localized
        $0.textColor = .starPrimaryText
    }
    
    let restButton = GradientButton(type: .system).then {
        $0.setTitle("break_mode.break_button".localized, for: .normal)
        $0.setTitleColor(.starTertiaryText, for: .normal)
        $0.titleLabel?.font = UIFont.System.bold16
        $0.backgroundColor = .starDisabledTagBG
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
        $0.applyGradient(colors: [.starButtonWhite, .starButtonYellow],
                         direction: .horizontal)
    }
    
    init(restingCompleteRelay: PublishRelay<Date>) {
        self.restSettingCompleteRelay = restingCompleteRelay
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .starModalBG
    
        view.addSubviews(titleLabel, textLabel, pickerView, restButton)
        
        pickerView.addSubview(pickerLabel)
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(textLabel.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(36)
        }
        
        textLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(24)
            $0.bottom.equalTo(pickerView.snp.top)
        }
        
        pickerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(restButton.snp.top).offset(-40)
            $0.width.equalTo(280)
            $0.height.equalTo(140)
        }
        
        pickerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(pickerView.snp.centerX).offset(16)
        }
        
        restButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - bind

extension RestSettingModalViewController {
    
    private func bind() {
        // UIPickerView에 data 연결
        pickerData.map { $0.map { "\($0)" } }.bind(to: pickerView.rx.itemTitles) { _, item in
            return item
        }.disposed(by: disposeBag)
        
        // 휴식하기 버튼 이벤트 : 휴식시간 저장
        restButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // pickerView에서 선택한 wheel의 인덱스 값 + 1 (인덱스 : 0 ~ 19)
                let restTime = owner.pickerView.selectedRow(inComponent: 0) + 1
                // 휴식시간 저장
                guard let time = RestManager().restEndTimeSet(restTime) else { return }
                NotificationManager().restEndNotification()
                owner.dismiss(animated: true) // 모달 창 닫기
                owner.restSettingCompleteRelay.accept(time)
            }).disposed(by: disposeBag)
    }
}

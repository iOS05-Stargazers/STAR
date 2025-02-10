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
    
    private let disposeBag = DisposeBag()
    
    // picker 데이터
    private let pickerData = Observable.just((0...20).map { String($0) })
    
    private let titleLabel = UILabel().then {
        $0.text = "휴식하기"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    private let textLabel = UILabel().then {
        $0.numberOfLines = 0 // 여러 줄 표시
        $0.text = "최대 20분까지 설정할 수 있습니다."
        $0.font = Fonts.modalSubtitle
        $0.textColor = .starPrimaryText
        $0.textAlignment = .center
    }
    
    private let pickerView = UIPickerView().then {
        $0.backgroundColor = .starAlertBG
        $0.setValue(UIColor.starPrimaryText, forKey: "textColor")
    }
    
    private let pickerLabel = UILabel().then {
        $0.text = "분"
        $0.textColor = .starPrimaryText
    }
    
    let restButton = GradientButton(type: .system).then {
        $0.setTitle("휴식하기", for: .normal)
        $0.setTitleColor(.starButtonNavy, for: .normal)
        $0.titleLabel?.font = Fonts.buttonTitle
        $0.backgroundColor = .starDisabledTagBG
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
        $0.applyGradient(colors: [.starButtonWhite, .starButtonYellow], direction: .horizontal)
    }
        
    override func viewDidLoad() {
        setupUI()
        bind()
    }

    private func setupUI() {
        view.backgroundColor = .starModalBG
        
        view.addSubview(titleLabel)
        view.addSubview(textLabel)
        pickerView.addSubview(pickerLabel)
        view.addSubview(pickerView)
        view.addSubview(restButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(36)
        }
        
        textLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(24)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        pickerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textLabel.snp.bottom).offset(30)
            $0.width.equalTo(280)
            $0.height.equalTo(140)
        }
        
        pickerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(pickerView.snp.centerX).offset(16)
        }
        
        restButton.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(40)
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - bind

extension RestSettingModalViewController {
    
    private func bind() {
        // UIPickerView에 data 연결
        pickerData.bind(to: pickerView.rx.itemTitles) { _, item in
            return "\(item)"
        }.disposed(by: disposeBag)
        
        // 휴식하기 버튼 클릭 이벤트
        restButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                print(owner.pickerView.selectedRow(inComponent: 0))
            }).disposed(by: disposeBag)
    }
}

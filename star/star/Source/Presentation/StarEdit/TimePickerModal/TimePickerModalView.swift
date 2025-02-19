//
//  PickerModalView.swift
//  star
//
//  Created by 안준경 on 2/13/25.
//

import UIKit
import SnapKit
import Then

final class TimePickerModalView: UIView {
    
    let titleLabel = UILabel().then {
        $0.font = UIFont.System.semibold24
        $0.textColor = .starPrimaryText
    }
    
    let pickerView = UIPickerView().then {
        $0.backgroundColor = .clear
        $0.setValue(UIColor.starPrimaryText, forKey: "textColor")
    }
    
    private let colon = UILabel().then {
        $0.text = ":"
        $0.textColor = .starSecondaryText
        $0.font = UIFont.System.semibold20
    }
    
    private let grabber = CustomGrabberView()
    
    let timeSelectButton = GradientButton(type: .system).then {
        $0.setTitle("설정하기", for: .normal)
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.titleLabel?.font = UIFont.System.black16
        $0.backgroundColor = .starDisabledTagBG // 그라디언트가 정상적으로 적용될 시 배경색은 보이지 않음
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
        $0.applyGradient(colors: [.starButtonPurple, .starButtonNavy], direction: .horizontal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .starModalBG
        
        pickerView.addSubview(colon)
        addSubviews(titleLabel, pickerView, timeSelectButton, grabber)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(pickerView.snp.top)
        }
        
        pickerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(timeSelectButton.snp.top).offset(-40)
            $0.width.equalTo(200)
        }
        
        colon.snp.makeConstraints {
            $0.centerY.equalTo(pickerView).offset(-2)
            $0.centerX.equalTo(pickerView)
        }
        
        timeSelectButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.height.equalTo(56)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        grabber.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(8)
        }
    }
}

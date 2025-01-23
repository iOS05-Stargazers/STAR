//
//  StarModalView.swift
//  star
//
//  Created by t2023-m0072 on 1/22/25.
//

import UIKit
import SnapKit
import Then

final class StarModalView: UIView {
        
    private let titleLabel = UILabel().then {
        $0.text = "스타 생성"
        $0.textColor = .starPrimaryText
        $0.font = Fonts.modalTitle
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "잠금할 앱과 시간을 설정해 주세요"
        $0.textColor = .starSecondaryText
        $0.font = Fonts.modalSubtitle
    }
    
    // nameLabel, nameTextField를 담는 스택뷰
    private let nameStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .starModalSectionBG
        $0.layer.cornerRadius = 10
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.textColor = .starPrimaryText
        $0.font = Fonts.modalSectionTitle
    }
    
    private let nameTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "이름을 입력하세요", attributes: [.foregroundColor: UIColor.starSecondaryText])
        $0.textColor = .starPrimaryText
        $0.font = Fonts.modalSectionOption
    }
    
    // appLockLabel, appLockButton를 담는 스택뷰
    private let appLockStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .starModalSectionBG
        $0.layer.cornerRadius = 10
    }
    
    private let appLockLabel = UILabel().then {
        $0.text = "앱 잠금"
        $0.textColor = .starPrimaryText
        $0.font = Fonts.modalSectionTitle
    }
    
    private let appLockButton = UIButton(type: .system).then {
        $0.setTitle("없음 >", for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = Fonts.modalSectionOption
    }
    
    // repeatCycleLabel, weekStackView, startTimeStackView, endTimeStackView을 담는 스택뷰
    private let scheduleConfigStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .starModalSectionBG
        $0.layer.cornerRadius = 10
    }
    
    private let repeatCycleLabel = UILabel().then {
        $0.text = "반복 주기"
        $0.textColor = .starPrimaryText
        $0.font = Fonts.modalSectionTitle
    }
    
    // 요일 버튼을 담는 스택뷰
    private let weekStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    // 요일 버튼
    private let mondayButton = UIButton(type: .system).then {
        $0.setTitle("월", for: .normal)
        $0.setTitleColor(.starSecondaryText, for: .normal)
        $0.backgroundColor = .starModalBG
        $0.layer.cornerRadius = 18
        $0.titleLabel?.font = Fonts.modalDayOption
    }
    
    private let tuesdayButton = UIButton(type: .system).then {
        $0.setTitle("화", for: .normal)
        $0.setTitleColor(.starSecondaryText, for: .normal)
        $0.backgroundColor = .starModalBG
        $0.layer.cornerRadius = 18
        $0.titleLabel?.font = Fonts.modalDayOption
    }
    
    private let wednesdayButton = UIButton(type: .system).then {
        $0.setTitle("수", for: .normal)
        $0.setTitleColor(.starSecondaryText, for: .normal)
        $0.backgroundColor = .starModalBG
        $0.layer.cornerRadius = 18
        $0.titleLabel?.font = Fonts.modalDayOption
    }
    
    private let thursdayButton = UIButton(type: .system).then {
        $0.setTitle("목", for: .normal)
        $0.setTitleColor(.starSecondaryText, for: .normal)
        $0.backgroundColor = .starModalBG
        $0.layer.cornerRadius = 18
        $0.titleLabel?.font = Fonts.modalDayOption
    }
    
    private let fridayButton = UIButton(type: .system).then {
        $0.setTitle("금", for: .normal)
        $0.setTitleColor(.starSecondaryText, for: .normal)
        $0.backgroundColor = .starModalBG
        $0.layer.cornerRadius = 18
        $0.titleLabel?.font = Fonts.modalDayOption
    }
    private let saturdayButton = UIButton(type: .system).then {
        $0.setTitle("토", for: .normal)
        $0.setTitleColor(.starSecondaryText, for: .normal)
        $0.backgroundColor = .starModalBG
        $0.layer.cornerRadius = 18
        $0.titleLabel?.font = Fonts.modalDayOption
    }
    
    private let sundayButton = UIButton(type: .system).then {
        $0.setTitle("일", for: .normal)
        $0.setTitleColor(.starSecondaryText, for: .normal)
        $0.backgroundColor = .starModalBG
        $0.layer.cornerRadius = 18
        $0.titleLabel?.font = Fonts.modalDayOption
    }
    
    // startTimeLabel, startTimeButton을 담는 스택뷰
    private let startTimeStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private let startTimeLabel = UILabel().then {
        $0.text = "시작 시간"
        $0.textColor = .starPrimaryText
        $0.font = Fonts.modalSectionTitle
    }
    
    private let startTimeButton = UIButton(type: .system).then {
        $0.setTitle("00:00", for: .normal)
        $0.tintColor = .starSecondaryText
        $0.titleLabel?.font = Fonts.modalSectionOption
    }
    
    // endTimeLabel, endTimeButton을 담는 스택뷰
    private let endTimeStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private let endTimeLabel = UILabel().then {
        $0.text = "종료 시간"
        $0.textColor = .starPrimaryText
        $0.font = Fonts.modalSectionTitle
    }
    
    private let endTimeButton = UIButton(type: .system).then {
        $0.setTitle("00:00", for: .normal)
        $0.tintColor = .starSecondaryText
        $0.titleLabel?.font = Fonts.modalSectionOption
    }
    
    // MARK: - 초기화
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .starModalBG
        
        // 이름
        [nameLabel, nameTextField]
            .forEach {
                nameStackView.addSubview($0)
            }
        
        // 앱 잠금
        [appLockLabel, appLockButton]
            .forEach {
                appLockStackView.addSubview($0)
            }
        
        // 요일
        [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton]
            .forEach {
                weekStackView.addSubview($0)
            }
        
        // 시작시간
        [startTimeLabel, startTimeButton]
            .forEach {
                startTimeStackView.addSubview($0)
            }
        
        // 종료시간
        [endTimeLabel, endTimeButton]
            .forEach {
                endTimeStackView.addSubview($0)
            }
        
        [repeatCycleLabel, weekStackView, startTimeStackView, endTimeStackView]
            .forEach {
                scheduleConfigStackView.addSubview($0)
            }
                
        [titleLabel, subtitleLabel, nameStackView, appLockStackView, scheduleConfigStackView]
            .forEach {
                addSubview($0)
            }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64)
            $0.leading.equalToSuperview().offset(20)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nameStackView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(18)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameStackView)
            $0.leading.equalTo(nameStackView).offset(16)
        }
        
        nameTextField.snp.makeConstraints {
            $0.centerY.equalTo(nameStackView)
            $0.trailing.equalTo(nameStackView).inset(16)
        }
        
        appLockStackView.snp.makeConstraints {
            $0.top.equalTo(nameStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        
        appLockLabel.snp.makeConstraints {
            $0.centerY.equalTo(appLockStackView)
            $0.leading.equalTo(appLockStackView).offset(16)
        }
        
        appLockButton.snp.makeConstraints {
            $0.centerY.equalTo(appLockStackView)
            $0.trailing.equalTo(appLockStackView).inset(16)
        }
        
        scheduleConfigStackView.snp.makeConstraints {
            $0.top.equalTo(appLockStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(203)
        }
        
        repeatCycleLabel.snp.makeConstraints {
            $0.top.equalTo(scheduleConfigStackView.snp.top).inset(16)
            $0.leading.equalTo(scheduleConfigStackView.snp.leading).inset(16)
        }

        weekStackView.snp.makeConstraints {
            $0.top.equalTo(repeatCycleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(scheduleConfigStackView.snp.leading).inset(16)
            $0.trailing.equalTo(scheduleConfigStackView.snp.leading).inset(16)
            $0.height.equalTo(36)
        }
        
        mondayButton.snp.makeConstraints {
            $0.top.equalTo(weekStackView)
            $0.leading.equalTo(weekStackView)
            $0.width.equalTo(36)
            $0.height.equalTo(36)
        }
        
        tuesdayButton.snp.makeConstraints {
            $0.top.equalTo(weekStackView)
            $0.leading.equalTo(mondayButton.snp.trailing).offset(13)
            $0.width.equalTo(36)
            $0.height.equalTo(36)
        }
        
        wednesdayButton.snp.makeConstraints {
            $0.top.equalTo(weekStackView)
            $0.leading.equalTo(tuesdayButton.snp.trailing).offset(13)
            $0.width.equalTo(36)
            $0.height.equalTo(36)
        }
        
        thursdayButton.snp.makeConstraints {
            $0.top.equalTo(weekStackView)
            $0.leading.equalTo(wednesdayButton.snp.trailing).offset(13)
            $0.width.equalTo(36)
            $0.height.equalTo(36)
        }
        
        fridayButton.snp.makeConstraints {
            $0.top.equalTo(weekStackView)
            $0.leading.equalTo(thursdayButton.snp.trailing).offset(13)
            $0.width.equalTo(36)
            $0.height.equalTo(36)
        }
        
        saturdayButton.snp.makeConstraints {
            $0.top.equalTo(weekStackView)
            $0.leading.equalTo(fridayButton.snp.trailing).offset(13)
            $0.width.equalTo(36)
            $0.height.equalTo(36)
        }
        
        sundayButton.snp.makeConstraints {
            $0.top.equalTo(weekStackView)
            $0.leading.equalTo(saturdayButton.snp.trailing).offset(13)
            $0.width.equalTo(36)
            $0.height.equalTo(36)
        }

        startTimeStackView.snp.makeConstraints {
            $0.top.equalTo(weekStackView.snp.bottom).offset(16)
            $0.leading.equalTo(scheduleConfigStackView.snp.leading).inset(16)
            $0.trailing.equalTo(scheduleConfigStackView).inset(16)
            $0.height.equalTo(52)
        }
        
        startTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(startTimeStackView)
            $0.leading.equalTo(startTimeStackView)
        }
        
        startTimeButton.snp.makeConstraints {
            $0.centerY.equalTo(startTimeStackView)
            $0.trailing.equalTo(startTimeStackView.snp.trailing)
        }

        endTimeStackView.snp.makeConstraints {
            $0.top.equalTo(startTimeStackView.snp.bottom)
            $0.leading.equalTo(scheduleConfigStackView.snp.leading).inset(16)
            $0.trailing.equalTo(scheduleConfigStackView).inset(16)
            $0.height.equalTo(52)
        }
        
        endTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(endTimeStackView)
            $0.leading.equalTo(endTimeStackView)
        }
        
        endTimeButton.snp.makeConstraints {
            $0.centerY.equalTo(endTimeStackView)
            $0.trailing.equalTo(endTimeStackView.snp.trailing)
        }
    }
    
}

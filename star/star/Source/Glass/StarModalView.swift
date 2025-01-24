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
    
    // 모달 섹션 타이틀 생성 함수
    private func makeLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .starPrimaryText
        label.font = Fonts.modalSectionTitle
        return label
    }
        
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
    
    private lazy var nameLabel = makeLabel("이름")
    
    let nameTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "이름을 입력하세요", attributes: [.foregroundColor: UIColor.starSecondaryText])
        $0.textColor = .starPrimaryText
        $0.font = Fonts.modalSectionOption
        $0.textAlignment = .right
    }
    
    // appLockLabel, appLockButton를 담는 스택뷰
    private let appLockStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .starModalSectionBG
        $0.layer.cornerRadius = 10
    }
    
    private lazy var appLockLabel = makeLabel("앱 잠금")
    
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
    
    private lazy var repeatCycleLabel = makeLabel("반복 주기")
    
    // 요일 버튼을 담는 스택뷰
    private let weekStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    
    // 요일 버튼 생성 함수
    private func makeButton(_ title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.starSecondaryText, for: .normal)
        button.backgroundColor = .starModalBG
        button.layer.cornerRadius = 18
        button.titleLabel?.font = Fonts.modalDayOption
        return button
    }
    
    private lazy var mondayButton = makeButton("월")
    private lazy var tuesdayButton = makeButton("화")
    private lazy var wednesdayButton = makeButton("수")
    private lazy var thursdayButton = makeButton("목")
    private lazy var fridayButton = makeButton("금")
    private lazy var saturdayButton = makeButton("토")
    private lazy var sundayButton = makeButton("일")
    
    // startTimeLabel, startTimeButton을 담는 스택뷰
    private let startTimeStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private lazy var startTimeLabel = makeLabel("시작 시간")
    
    private let startTimeButton = UIButton(type: .system).then {
        $0.setTitle("00:00", for: .normal)
        $0.tintColor = .starSecondaryText
        $0.titleLabel?.font = Fonts.modalSectionOption
    }
    
    // endTimeLabel, endTimeButton을 담는 스택뷰
    private let endTimeStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private lazy var endTimeLabel = makeLabel("종료 시간")
    
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
                weekStackView.addArrangedSubview($0)
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
            $0.height.equalTo(36)
            $0.width.equalTo(scheduleConfigStackView.snp.width).inset(16)
        }

        // 디바이스에 따라 요일 버튼 너비 조절
        [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton].forEach { button in
            button.snp.makeConstraints {
                $0.top.equalTo(weekStackView)
                $0.width.equalTo(button.snp.height)
            }
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

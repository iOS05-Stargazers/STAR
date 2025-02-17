//
//  StarEditView.swift
//  star
//
//  Created by 안준경 on 1/22/25.
//

import UIKit
import SnapKit
import Then

final class StarEditView: UIView {
    
    // MARK: - 모달 구성 UI
    
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
    
    lazy var nameTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "이름을 입력하세요", attributes: [.foregroundColor: UIColor.starSecondaryText])
        $0.textColor = .starPrimaryText
        $0.font = Fonts.modalSectionOption
        $0.textAlignment = .right
        $0.rightView = clearButton
        $0.rightViewMode = .whileEditing
    }
    
    let clearButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .starModalBG
    }
    
    // appLockLabel, appLockButton를 담는 스택뷰
    private let appLockStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .starModalSectionBG
        $0.layer.cornerRadius = 10
    }
    
    private lazy var appLockLabel = makeLabel("앱 잠금")
    
    let appLockButton = UIButton(type: .system).then {
        $0.setTitle("선택 >", for: .normal)
        $0.setTitleColor(.starSecondaryText, for: .normal)
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
    
    // 요일 버튼(반복 주기)
    let mondayButton = WeekDayButton(weekDay: .mon)
    let tuesdayButton = WeekDayButton(weekDay: .tue)
    let wednesdayButton = WeekDayButton(weekDay: .wed)
    let thursdayButton = WeekDayButton(weekDay: .thu)
    let fridayButton = WeekDayButton(weekDay: .fri)
    let saturdayButton = WeekDayButton(weekDay: .sat)
    let sundayButton = WeekDayButton(weekDay: .sun)
    
    lazy var weekButtons: [WeekDayButton] = [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton]
    
    // startTimeLabel, startTimeButton을 담는 스택뷰
    private let startTimeStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private lazy var startTimeLabel = makeLabel("시작 시간")
    
    let startTimeButton = UIButton(type: .system).then {
        $0.setTitle("00:00", for: .normal)
        $0.setTitleColor(.starSecondaryText, for: .normal)
        $0.titleLabel?.font = Fonts.modalSectionOption
    }
    
    // endTimeLabel, endTimeButton을 담는 스택뷰
    private let endTimeStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private lazy var endTimeLabel = makeLabel("종료 시간")
    
    let endTimeButton = UIButton(type: .system).then {
        $0.setTitle("23:59", for: .normal)
        $0.setTitleColor(.starSecondaryText, for: .normal)
        $0.titleLabel?.font = Fonts.modalSectionOption
    }
    
    let addStarButton = GradientButton(type: .system).then {
        $0.setTitle("생성하기", for: .normal)
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.titleLabel?.font = Fonts.buttonTitle
        $0.backgroundColor = .starDisabledTagBG // 그라디언트가 정상적으로 적용될 시 배경색은 보이지 않음
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
        $0.applyGradient(colors: [.starButtonPurple, .starButtonNavy], direction: .horizontal)
    }
    
    // MARK: - 토스트
    
    // 토스트 뷰
    let toastMessageView = ToastMessageView()
    
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
        [
            nameLabel,
            nameTextField
        ].forEach { nameStackView.addSubview($0) }
        
        // 앱 잠금
        [
            appLockLabel,
            appLockButton
        ].forEach { appLockStackView.addSubview($0) }
        
        // 반복 주기 - 요일버튼 추가
        weekButtons.forEach {
            weekStackView.addArrangedSubview($0)
        }
        
        // 시작시간
        [
            startTimeLabel,
            startTimeButton
        ].forEach { startTimeStackView.addSubview($0) }
        
        // 종료시간
        [
            endTimeLabel,
            endTimeButton
        ].forEach { endTimeStackView.addSubview($0) }
        
        [
            repeatCycleLabel,
            weekStackView,
            startTimeStackView,
            endTimeStackView
        ].forEach { scheduleConfigStackView.addSubview($0) }
        
        [
            titleLabel,
            subtitleLabel,
            nameStackView,
            appLockStackView,
            scheduleConfigStackView,
            addStarButton,
            toastMessageView
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(subtitleLabel.snp.top).offset(-8)
            $0.leading.equalToSuperview().offset(20)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(nameStackView.snp.top).offset(-20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nameStackView.snp.makeConstraints {
            $0.bottom.equalTo(appLockStackView.snp.top).offset(-20)
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
            $0.width.equalTo(250)
        }
        
        appLockStackView.snp.makeConstraints {
            $0.bottom.equalTo(scheduleConfigStackView.snp.top).offset(-20)
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
            $0.bottom.equalTo(addStarButton.snp.top).offset(-30)
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
        weekButtons.forEach { button in
            button.snp.makeConstraints {
                $0.top.equalTo(weekStackView)
                $0.width.equalTo(button.snp.height)
            }
            
            button.layer.cornerRadius = 18
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
        
        addStarButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.height.equalTo(56)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        toastMessageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(addStarButton.snp.top).offset(-20)
        }
    }
}

// MARK: - 데이터 설정

extension StarEditView {
    
    func configure(star: Star) {
        titleLabel.text = "스타 수정"
        addStarButton.setTitle("수정하기", for: .normal)
        nameTextField.text = star.title
        
        let starTime = star.schedule.startTime.coreDataForm()
        let endTime = star.schedule.endTime.coreDataForm()
        startTimeButton.setTitle(starTime, for: .normal)
        endTimeButton.setTitle(endTime, for: .normal)
    }
}

//
//  WeekDayButton.swift
//  star
//
//  Created by 0-jerry on 2/5/25.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

final class WeekDayButton: GradientButton {
    private let disposeBag = DisposeBag()
    private let buttonStateRelay: BehaviorRelay<Bool>
    // 요일
    let weekDay: WeekDay
    // 버튼 상태 방출
    var buttonState: Driver<(WeekDay, Bool)> {
        let weekDay = self.weekDay
        return buttonStateRelay.asDriver(onErrorDriveWith: .empty()).map { state in (weekDay, state) }
    }
    
    init(weekDay: WeekDay, state: Bool = false) {
        self.weekDay = weekDay
        self.buttonStateRelay = BehaviorRelay<Bool>(value: state)
        super.init(frame: .zero)
        gradientLayer.isHidden = !state
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setTitle(weekDay.korean, for: .normal)
        setTitleColor(.starSecondaryText, for: .normal)
        titleLabel?.font = Fonts.modalDayOption
        clipsToBounds = true
        backgroundColor = .starDisabledTagBG
        
        applyGradient(colors: [.starButtonNavy, .starButtonPurple],
                           direction: .vertical)
        
        bind()
    }
    
    private func toggle() {
        gradientLayer.isHidden.toggle()
        buttonStateRelay.accept(!gradientLayer.isHidden)
        // 테스트 출력문
//        print("\(weekDay.korean) 버튼 - 색: \(!gradientLayer.isHidden) / 상태: \(buttonStateRelay.value)")
    }
    
    func setState(_ state: Bool) {
        self.buttonStateRelay.accept(state)
        gradientLayer.isHidden = !state
    }
    
    private func bind() {
        self.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.toggle()
            }).disposed(by: disposeBag)
    }
}

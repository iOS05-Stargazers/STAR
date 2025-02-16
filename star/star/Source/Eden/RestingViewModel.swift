//
//  RestingViewModel.swift
//  star
//
//  Created by Eden on 2/6/25.
//

import Foundation
import RxSwift
import RxCocoa

final class RestingViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let timerSubject: BehaviorRelay<Int>
    private let timerEndedSubject = PublishRelay<Void>()
    
    init() {
        if let time = UserDefaults.appGroups.restEndTimeGet()?.timeIntervalSince(.now) {
            self.timerSubject = .init(value: Int(time))
        } else {
            self.timerSubject = .init(value: 1200)
        }
    }
    
    // MARK: - Format Time
    
    private func formatTime(_ seconds: Int) -> String {
        let min = (seconds % 3600) / 60
        let sec = seconds % 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    // MARK: - Timer 카운트 다운 로직
    
    private func startCountdown() {
        Observable<Int>.timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .map { owner, _ in
                guard let time = UserDefaults.appGroups.restEndTimeGet()?.timeIntervalSince(.now) else { return (owner, 0) }
                return (owner, Int(time))
            }.subscribe(onNext: { owner, value in
                if value > 0 {
                    owner.timerSubject.accept(value)
                } else {
                    owner.timerEndedSubject.accept(())
                }
            }).disposed(by: disposeBag)
    }
}

extension RestingViewModel {
    
    struct Input {
        let startTimer: Signal<Void>
        let stopTimer: Signal<Void>
    }
    
    struct Output {
        let timerText: Driver<String>
        let timerEnded: Signal<Void>
    }
    
    func transform(input: Input) -> Output {
        input.startTimer
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.startCountdown()
            })
            .disposed(by: disposeBag)
        
        input.stopTimer
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                UserDefaults.standard.restEndTimeDelete()
                owner.timerSubject.accept(0)
                owner.timerEndedSubject.accept(())
            })
            .disposed(by: disposeBag)
        
        let timerText = timerSubject
            .map { self.formatTime($0) }
            .asDriver(onErrorJustReturn: "00:00")
        
        return Output(
            timerText: timerText,
            timerEnded: timerEndedSubject.asSignal()
        )
    }
}

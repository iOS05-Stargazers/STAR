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
    
    // MARK: - Format Time
    
    private func formatTime(_ seconds: Int) -> String {
        let min = (seconds % 3600) / 60
        let sec = seconds % 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    // MARK: - Timer 로직
    
    private func createCountdownTimer(initialTime: Int) -> Observable<Int> {
        return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .scan(initialTime) { current, _ in max(current - 1, 0) } // 1초마다 -1 감소, 0 이하로 안 내려감
            .distinctUntilChanged()
            .startWith(initialTime)
    }
}

extension RestingViewModel {
    
    struct Input {
        let startTimer: Observable<Void>
        let stopTimer: Observable<Void>
    }
    
    struct Output {
        let timerText: Driver<String>
        let timerEnded: Signal<Void>
    }
    
    func transform(input: Input, initialTime: Int) -> Output {
        let timerSubject = BehaviorRelay<Int>(value: initialTime)
        let timerEndedSubject = PublishRelay<Void>()
        
        input.startTimer
            .flatMapLatest { self.createCountdownTimer(initialTime: initialTime) }
            .do (onNext: { time in
                if time == 0 {
                    timerEndedSubject.accept(()) // 타이머가 0이면 이벤트 발생
                }
            })
            .bind(to: timerSubject)
            .disposed(by: disposeBag)
        
        input.stopTimer
            .subscribe(onNext: { _ in
                timerSubject.accept(initialTime)
            })
            .disposed(by: disposeBag)
        
        let timerText = timerSubject
            .map { self.formatTime($0) }
            .asDriver(onErrorJustReturn: "00:00")
        
        return Output(timerText: timerText, timerEnded: timerEndedSubject.asSignal())
    }
}

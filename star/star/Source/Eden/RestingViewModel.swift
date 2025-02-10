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
            .flatMapLatest { _ in
                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                    .map { _ in -1 } // 1초마다 -1 감소
            }
            .withLatestFrom(timerSubject) { decrement, current in
                max(current + decrement, 0) // 0 이하로 내려가지 않도록
            }
            .distinctUntilChanged() // 0 한 번만 방출
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
            .map { seconds -> String in
                let minutes = (seconds % 3600) / 60
                let secs = seconds % 60
                return String(format: "%02d:%02d", minutes, secs)
            }
            .asDriver(onErrorJustReturn: "00:00")
        
        return Output(timerText: timerText, timerEnded: timerEndedSubject.asSignal())
    }
}

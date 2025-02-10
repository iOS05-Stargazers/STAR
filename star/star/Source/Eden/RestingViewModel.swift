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
    }
    
    func transform(input: Input, initialTime: Int) -> Output {
        let timerSubject = BehaviorRelay<Int>(value: initialTime)
        
        input.startTimer
            .flatMapLatest { _ in
                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                    .map { _ in -1 } // 1초마다 -1 감소
            }
            .withLatestFrom(timerSubject) { decrement, current in
                max(current + decrement, 0) // 0 이하로 내려가지 않도록
            }
            .distinctUntilChanged()
            .bind(to: timerSubject)
            .disposed(by: disposeBag)
        
        input.stopTimer
            .subscribe(onNext: { _ in
                timerSubject.accept(0)
            })
            .disposed(by: disposeBag)
        
        let timerText = timerSubject
            .map { seconds -> String in
                let hours = seconds / 3600
                let minutes = (seconds % 3600) / 60
                let secs = seconds % 60
                return String(format: "%02d:%02d:%02d", hours, minutes, secs)
            }
            .asDriver(onErrorJustReturn: "00:00:00")
        
        return Output(timerText: timerText)
    }
}

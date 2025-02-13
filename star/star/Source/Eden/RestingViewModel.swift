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
    private let initialTime: Int
    
    private let timerSubject: BehaviorRelay<Int>
    private let timerEndedSubject = PublishRelay<Void>()
    
    init(initialTime: Int) {
        self.initialTime = initialTime
        self.timerSubject = BehaviorRelay<Int>(value: initialTime)
    }
    
    // MARK: - Format Time
    
    private func formatTime(_ seconds: Int) -> String {
        let min = (seconds % 3600) / 60
        let sec = seconds % 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    // MARK: - 휴식시간 삭제
    
    private func removeRestEndTime() {
        UserDefaults.standard.removeObject(forKey: "restEndTime")
    }
    
    // MARK: - Timer 로직
    
    private func createCountdownTimer() -> Observable<Int> {
        return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .scan(initialTime) { current, _ in max(current - 1, 0) } // 1초마다 -1 감소, 0 이하로 안 내려감
            .take(while: { $0 > 0 }) // complete 타이머가 0이 되면 자동 종료
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
    
    func transform(input: Input) -> Output {
        input.startTimer
            .flatMapLatest { [weak self] in
                guard let self = self else { return Observable<Int>.empty() }
                return self.createCountdownTimer()
            }
            .do(onNext: { time in
                if time == 0 {
                    self.timerEndedSubject.accept(())
                }
            })
            .bind(to: timerSubject)
            .disposed(by: disposeBag)
        
        input.stopTimer
            .subscribe(with: self) { owner, _ in
                owner.timerSubject.accept(owner.initialTime)
            }
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

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
    
    private let timerSubject = PublishRelay<Int>()
    private let timerEndedSubject = PublishRelay<Void>()
    
    // MARK: - Format Time
    
    private func formatTime(_ seconds: Int) -> String {
        let min = (seconds % 3600) / 60
        let sec = seconds % 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    // MARK: - Timer 카운트 다운 로직
    
    private func startCountdown() {
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .map {  _ in
                guard let time = RestManager().restEndTimeGet()?.timeIntervalSince(.now) else { return 0 }
                return Int(time) }
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
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
                RestManager().restEndTimeDelete() // 휴식시간 종료될 때 저장된 시간 삭제
                NotificationManager().removeRest()
                owner.timerSubject.accept(0)
                owner.timerEndedSubject.accept(())
            })
            .disposed(by: disposeBag)
        
        let timerText = timerSubject
            .withUnretained(self)
            .map { owenr, value in
                owenr.formatTime(value)
            }
            .asDriver(onErrorJustReturn: "00:00")
        
        return Output(
            timerText: timerText,
            timerEnded: timerEndedSubject.asSignal()
        )
    }
}

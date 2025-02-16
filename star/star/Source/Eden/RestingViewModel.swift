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
    
    // MARK: - Timer 카운트 다운 로직
    
    private func startCountdown() {
        Observable<Int>.timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .take(initialTime)
            .subscribe(onNext: { owner, _ in
                let newValue = max(owner.timerSubject.value - 1, 0)
                owner.timerSubject.accept(newValue)
            }, onCompleted: { [weak self] in
                guard let self = self else { return }
                UserDefaults.appGroups.restEndTimeDelete() // 휴식시간 종료될 때 저장된 시간 삭제
                FamilyControlsManager().updateBlockList()
                self.timerEndedSubject.accept(()) // 모달 닫기 이벤트 실행
            })
            .disposed(by: disposeBag)
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
                UserDefaults.appGroups.restEndTimeDelete() // 휴식시간 종료될 때 저장된 시간 삭제
                FamilyControlsManager().updateBlockList()
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

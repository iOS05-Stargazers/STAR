//
//  RestStartViewModel.swift
//  star
//
//  Created by 서문가은 on 2/10/25.
//

import Foundation
import RxSwift
import RxCocoa

enum DelayMode {
    
    case rest
    case edit(star: Star)
    case delete(star: Star)
}

final class DelayViewModel {
    
    private let countRelay = BehaviorRelay(value: 5)
    private let completeRelay = PublishRelay<Void>()
    let delayCompleteRelay: PublishRelay<DelayMode> // 휴식 진입 화면 완료 릴레이 -> 메인 화면에서 이벤트 방출 받음
    private let disposeBag = DisposeBag()
    
    let mode: DelayMode
    
    init(delayCompleteRelay: PublishRelay<DelayMode>, mode: DelayMode) {
        self.delayCompleteRelay = delayCompleteRelay
        self.mode = mode
    }
    
    // 5초 카운트다운 실행
    private func startCountdown() {
        Observable<Int>.timer(.seconds(1),
                              period: .seconds(1),
                              scheduler: MainScheduler.instance)
        .withUnretained(self)
        .take(5) // 5번만 실행
        .subscribe(onNext: { owner, count in
            owner.countRelay.accept(owner.countRelay.value - 1) // 1씩 감소
        }, onCompleted: { [weak self] in
            self?.completeRelay.accept(())
            HapticManager.shared.play(style: .notification(.success))
        })
        .disposed(by: disposeBag)
    }
}

extension DelayViewModel {
    
    struct Output {
        let count: Driver<Int>
        let complete: Driver<Void>
    }
    
    func transform() -> Output {
        startCountdown()
        
        return Output(
            count: countRelay.asDriver(onErrorDriveWith: .empty()),
            complete: completeRelay.asDriver(onErrorDriveWith: .empty())
        )
    }
}

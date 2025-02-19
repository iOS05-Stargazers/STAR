//
//  StarListCollectionViewCellViewModel.swift
//  star
//
//  Created by 서문가은 on 1/27/25.
//

import RxSwift
import RxCocoa

final class StarListCollectionViewCellViewModel {
    
    private let state: BehaviorRelay<StarState.Style>
    private let time = BehaviorRelay<String>(value: "")
    private let star: Star
    private let disposeBag = DisposeBag()
    
    init(star: Star) {
        self.star = star
        self.state = BehaviorRelay<StarState.Style>(value: star.state().style)
        updateTime()
        startTimer()
    }
    
    // 타이머 시작
    private func startTimer() {
        Observable<Int>.timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.updateTime()
            })
            .disposed(by: disposeBag)
    }
    
    // 시간 업데이트
    private func updateTime() {
        if self.star.state().style == .ongoing {
            self.time.accept("\(StarStateFormatter.hhmmss(self.star.state().interval))")
        } else {
            self.time.accept("\(StarStateFormatter.korean(self.star.state().interval))")
        }
    }
}

extension StarListCollectionViewCellViewModel {
    
    struct Output {
        let timer: Driver<String>
        let state: Driver<StarState.Style>
    }
    
    func transform() -> Output {
        return Output(
            timer: time.asDriver(onErrorDriveWith: .empty()),
            state: state.asDriver(onErrorDriveWith: .empty()))
    }
}

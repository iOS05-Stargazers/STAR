//
//  StarListCollectionViewCellViewModel.swift
//  star
//
//  Created by 서문가은 on 1/27/25.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class StarListCollectionViewCellViewModel {
    
    private let state = BehaviorRelay<StarState.Style>(value: .ongoing)
    private let time = BehaviorRelay<String>(value: "")
    private let star: Star

    
    init(star: Star) {
        self.star = star
        updateTime()
        state.accept(star.state().style)
        startTimer()
    }
    
    // 타이머 시작
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.updateTime()
        })
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

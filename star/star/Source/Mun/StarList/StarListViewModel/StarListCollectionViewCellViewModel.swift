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
    private let state = PublishRelay<StarState.Style>()
    private let time = PublishRelay<String>()
    private var testTime = 0.0
    private let star: Star

    
    init(star: Star) {
        self.star = star
        changeTime()
    }
    
    private func changeTime() {
        print(Date.now)
        testTime = star.state().interval
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in

            self.state.accept(self.star.state().style)
            
            if self.star.state().style == .ongoing {
                self.time.accept("\(StarStateFormatter.hhmmss(self.testTime))")
            } else {
                self.time.accept("\(StarStateFormatter.korean(self.testTime))")
            }
            self.testTime -= 1
        })
        
    }
    
    func transform() -> Output {
        return Output(
            timer: time.asDriver(onErrorDriveWith: .empty()),
            state: state.asDriver(onErrorDriveWith: .empty()))
    }
    
    struct Output {
        let timer: Driver<String>
        let state: Driver<StarState.Style>
    }
    
}

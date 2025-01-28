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

enum State {
    case test
    case test2
}

class StarListCollectionViewCellViewModel {
    private let state = PublishRelay<State>()
    private let time = PublishRelay<String>()
    private var testTime = 10

    
    init() {
        changeTime()
    }
    
    private func changeTime() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in
            self.time.accept("\(self.testTime)")
            self.testTime += 1
            self.state.accept(State.test2)

        })
        
        state.accept(State.test2)
    }
    
    func transform() -> Output {
        return Output(
            timer: time.asDriver(onErrorDriveWith: .empty()),
            state: state.asDriver(onErrorDriveWith: .empty()))
    }
    
    struct Output {
        let timer: Driver<String>
        let state: Driver<State>
    }
    
}

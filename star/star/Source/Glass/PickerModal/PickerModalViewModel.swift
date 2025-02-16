//
//  PickerModalViewModel.swift
//  star
//
//  Created by 안준경 on 2/13/25.
//

import Foundation
import RxSwift
import RxCocoa

final class PickerModalViewModel {
    
    private let disposeBag = DisposeBag()
    private let startTimeRelay: PublishRelay<StarTime>
    private let endTimeRelay: PublishRelay<StarTime>
    
    let pickerMode: TimeType
    
    init(mode: TimeType,
         startTimeRelay: PublishRelay<StarTime>,
         endTimeRelay: PublishRelay<StarTime>) {
        self.pickerMode = mode
        self.startTimeRelay = startTimeRelay
        self.endTimeRelay = endTimeRelay
    }
    
    func transform(input: Input) -> Output{
        
        input.startTimeRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, starTime in
            owner.startTimeRelay.accept(starTime)
        }).disposed(by: disposeBag)
        
        input.endTimeRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, starTime in
            owner.endTimeRelay.accept(starTime)
        }).disposed(by: disposeBag)
        
        return Output(startTimeRelay: startTimeRelay.asDriver(onErrorDriveWith: .empty()),
                      endTimeRelay: endTimeRelay.asDriver(onErrorDriveWith: .empty()))
    }
    
}

extension PickerModalViewModel {
    
    struct Input {
        let startTimeRelay: Observable<StarTime>
        let endTimeRelay: Observable<StarTime>

    }
    
    struct Output {
        let startTimeRelay: Driver<StarTime>
        let endTimeRelay: Driver<StarTime>
    }
}

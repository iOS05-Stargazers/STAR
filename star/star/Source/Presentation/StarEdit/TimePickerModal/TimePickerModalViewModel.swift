//
//  PickerModalViewModel.swift
//  star
//
//  Created by 안준경 on 2/13/25.
//

import Foundation
import RxSwift
import RxCocoa

final class TimePickerModalViewModel {
    
    private let disposeBag = DisposeBag()
    private let startTimeRelay: PublishRelay<StarTime>
    private let endTimeRelay: PublishRelay<StarTime>
    
    // UIPickerView 데이터
    let hourData = Observable.just(Array(0...23))  // "0" ~ "23"
    let minuteData = Observable.just(Array(0...59)) // "0" ~ "59"
    
    // 시작시간/종료시간 구분 enum
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
                      endTimeRelay: endTimeRelay.asDriver(onErrorDriveWith: .empty()),
                      hourData: hourData.asDriver(onErrorDriveWith: .empty()),
                      minuteData: minuteData.asDriver(onErrorDriveWith: .empty()))
    }
}

extension TimePickerModalViewModel {
    
    struct Input {
        let startTimeRelay: Observable<StarTime>
        let endTimeRelay: Observable<StarTime>
        
    }
    
    struct Output {
        let startTimeRelay: Driver<StarTime>
        let endTimeRelay: Driver<StarTime>
        let hourData: Driver<Array<Int>>
        let minuteData: Driver<Array<Int>>
    }
}

//
//  StarModalViewModel.swift
//  star
//
//  Created by t2023-m0072 on 1/27/25.
//

import Foundation
import RxSwift
import RxCocoa

final class StarModalViewModel {
    
    private let coreData = CoreDataManager.shared
    private let starManager = StarManager.shared
    
    private let nameTextFieldRelay = BehaviorRelay<String>(value: "")
//    private let appLockRelay = PublishRelay<[AppID]>
//    private let weekButtonsRelay = PublishRelay
    private let startTimeRelay = BehaviorRelay<StarTime>(value: StarTime(hour: 00, minute: 00))
    private let endTimeRelay = BehaviorRelay<StarTime>(value: StarTime(hour: 23, minute: 59))
    private let addStarResultRelay = PublishRelay<String>()

    private let disposeBag = DisposeBag()
    
    init() {}
    
    func transform(input: Input) -> Output {
        
        // 스타 생성하기(더미데이터) TODO: 실제 데이터로 수정
        input.addStarTap.withLatestFrom(Observable.combineLatest(
            input.nameTextFieldInput,
            startTimeRelay,
            endTimeRelay
        )).subscribe(onNext: { [weak self] (name, startTime, endTime) in
            let star = Star(identifier: UUID(), title: name, blockList: [], schedule: Schedule(startTime: startTime, finishTime: endTime, weekDays: Set(WeekDay.allCases)))
            print("check")
            print(star)
            self?.starManager.create(star)
        }).disposed(by: disposeBag)
                                                     
        return Output(result: addStarResultRelay.asDriver(onErrorJustReturn: "에러 발생"))
    }
    
}

extension StarModalViewModel {
    
    struct Input {
        let nameTextFieldInput: Observable<String>
//        let appLockButtonTap: Observable<Void>
//        let weekButtonsTap: Observable<Void>
        let startTimePick: AnyObserver<String?>
        let endTimePick: AnyObserver<String?>
        let addStarTap: Observable<Void>
    }
    
    struct Output {
        let result: Driver<String>
    }
    
}

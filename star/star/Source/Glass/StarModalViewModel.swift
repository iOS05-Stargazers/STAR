//
//  StarModalViewModel.swift
//  star
//
//  Created by t2023-m0072 on 1/27/25.
//

import Foundation
import RxSwift
import RxCocoa

enum Mode {
    case create
    case edit(star: Star)
}

final class StarModalViewModel {
    
    private let coreData = CoreDataManager.shared
    private let starManager = StarManager.shared
    
    private let nameTextFieldRelay = BehaviorRelay<String>(value: "")
//    private let appLockRelay = PublishRelay<[AppID]>
//    private let weekButtonsRelay = PublishRelay
    private let startTimeRelay = BehaviorRelay<StarTime>(value: StarTime(hour: 00, minute: 00))
    private let endTimeRelay = BehaviorRelay<StarTime>(value: StarTime(hour: 23, minute: 59))
    private let addStarResultRelay = PublishRelay<String>()
    private let starRelay = BehaviorRelay<Star?>(value: nil)
    private let refreshRelay: PublishRelay<Void>

    private let disposeBag = DisposeBag()
    
    init(mode: Mode, refreshRelay: PublishRelay<Void>) {
        switch mode {
        case .create:
            print("")
        case .edit(let star):
            starRelay.accept(star)
        }
        self.refreshRelay = refreshRelay
    }
    
    func transform(input: Input) -> Output {
        
        // 스타 생성하기(더미데이터) TODO: 실제 데이터로 수정
        input.addStarTap.withLatestFrom(Observable.combineLatest(
            input.nameTextFieldInput,
            startTimeRelay,
            endTimeRelay
        )).subscribe(onNext: { [weak self] (name, startTime, endTime) in

            if let starRelay = self?.starRelay.value {
                let star = Star(identifier: starRelay.identifier, title: name, blockList: [], schedule: Schedule(startTime: startTime, finishTime: endTime, weekDays: Set(WeekDay.allCases)))
                self?.starManager.update(star)
            } else {
                let star = Star(identifier: UUID(), title: name, blockList: [], schedule: Schedule(startTime: startTime, finishTime: endTime, weekDays: Set(WeekDay.allCases)))
                self?.starManager.create(star)
            }

            self?.closeAlert()
        }).disposed(by: disposeBag)
                                                     
        return Output(result: addStarResultRelay.asDriver(onErrorJustReturn: "에러 발생"),
                      star: starRelay.asDriver(onErrorDriveWith: .empty()))
    }
    
    // 종료 방출
    private func closeAlert() {
        refreshRelay.accept(())
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
        let star: Driver<Star?>
    }
    
}

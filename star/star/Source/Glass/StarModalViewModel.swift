//
//  StarModalViewModel.swift
//  star
//
//  Created by t2023-m0072 on 1/27/25.
//

import Foundation
import RxSwift
import RxCocoa

enum StarModalMode {
    case create
    case edit(star: Star)
}

enum StarModalInputState {
    case noName
    case noSchedule
    case overFinishTime
    
    var text: String {
        switch self {
        case .noName:
            return "이름을 입력해주세요."
        case .noSchedule:
            return "하나 이상의 반복 주기를 선택해주세요."
        case .overFinishTime:
            return "시작 시간은 종료 시간보다 빨라야합니다."
        }
    }
}

final class StarModalViewModel {
    
    //    private let coreData = CoreDataManager.shared
    private let starManager = StarManager.shared
    private let scheduleVM = ScheduleVM()
    
    private let nameTextFieldRelay = BehaviorRelay<String>(value: "")
    //    private let appLockRelay = PublishRelay<[AppID]>
    //    private let weekButtonsRelay = PublishRelay
    private let startTimeRelay = BehaviorRelay<StarTime>(value: StarTime(hour: 00, minute: 00))
    private let endTimeRelay = BehaviorRelay<StarTime>(value: StarTime(hour: 23, minute: 59))
    private let addStarResultRelay = PublishRelay<String>()
    private let starRelay = BehaviorRelay<Star?>(value: nil)
    private let starModalInputStateRelay = PublishRelay<StarModalInputState>()
    private let refreshRelay: PublishRelay<Void>
    private let weekDaysRelay = BehaviorRelay<[WeekDay]>(value: [])
    private let familyControlsPickerRelay = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    init(mode: StarModalMode, refreshRelay: PublishRelay<Void>) {
        switch mode {
        case .create:
            print("")
        case .edit(let star):
            starRelay.accept(star)
        }
        self.refreshRelay = refreshRelay
    }
    
    func transform(input: Input) -> Output {
        // 앱 잠금 버튼 탭 시 FamilyControlsPicker(또는 FamilyActivitySelection) 호출
//        input.appLockButtonTap
//            .subscribe(onNext: { [weak self] in
//                guard let self = self else { return }
//                // 내부적으로 FamilyControlsPicker를 호출하는 메서드
//                self.scheduleVM.showFamilyActivitySelection()
//                // 뷰에 picker를 표시하도록 알림(예: viewController에서 이 이벤트를 받아서 present 처리)
//                self.familyControlsPickerRelay.accept(())
//            })
//            .disposed(by: disposeBag)
        
        // 스타 생성하기(더미데이터) TODO: 실제 데이터로 수정 - 수정 필요
//        input.addStarTap.withLatestFrom(
//            Observable.combineLatest(
//                input.nameTextFieldInput,
//                weekDaysRelay,
//                startTimeRelay,
//                endTimeRelay
//            )
//        ).subscribe(onNext: { [weak self] (name, weekDays, startTime, endTime) in
//            // 이름 확인
//            guard name != "" else {
//                self?.starModalInputStateRelay.accept(.noName)
//                return
//            }
//            
//            // 반복주기 확인
//            if weekDays.isEmpty {
//                self?.starModalInputStateRelay.accept(.noSchedule)
//                return
//            }
//            
//            // 시작시간이 종료시간보다 이른지 확인
//            if startTime.hour > endTime.hour ||
//                (startTime.hour == endTime.hour && startTime.minute >= endTime.minute) {
//                self?.starModalInputStateRelay.accept(.overFinishTime)
//                return
//            }
//            
//            if let starRelay = self?.starRelay.value {
//                let star = Star(identifier: starRelay.identifier, title: name, blockList: [], schedule: Schedule(startTime: startTime, finishTime: endTime, weekDays: Set(WeekDay.allCases)))
//                self?.starManager.update(star)
//            } else {
//                let star = Star(identifier: UUID(), title: name, blockList: [], schedule: Schedule(startTime: startTime, finishTime: endTime, weekDays: Set(WeekDay.allCases)))
//                self?.starManager.create(star)
//            }
//            
//            self?.closeAlert()
//        }).disposed(by: disposeBag)
        
        return Output(result: addStarResultRelay.asDriver(onErrorJustReturn: "에러 발생"),
                      star: starRelay.asDriver(onErrorDriveWith: .empty()),
                      starModalInputState: starModalInputStateRelay.asDriver(onErrorDriveWith: .empty()),
                      refresh: refreshRelay.asDriver(onErrorDriveWith: .empty()))
//                      familyControlsPicker: familyControlsPickerRelay.asDriver(onErrorDriveWith: .empty()))
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
        let starModalInputState: Driver<StarModalInputState>
        let refresh: Driver<Void>
//        let familyControlsPicker: Driver<Void>
    }
    
}

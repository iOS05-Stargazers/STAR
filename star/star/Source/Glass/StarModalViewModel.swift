//
//  StarModalViewModel.swift
//  star
//
//  Created by 안준경 on 1/27/25.
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
    
    private let starManager = StarManager.shared
    private let scheduleVM = ScheduleVM()
    
    private let weekDaysRelay: BehaviorRelay<Set<WeekDay>> = .init(value:[])
    private let addStarResultRelay = PublishRelay<String>()
    private let starRelay = BehaviorRelay<Star?>(value: nil)
    private let starModalInputStateRelay = PublishRelay<StarModalInputState>()
    private let refreshRelay: PublishRelay<Void>
    private let disposeBag = DisposeBag()
    
    private var starName: String = ""
    private var weekDays: Set<WeekDay> = [] // 선택 요일(반복 주기) 담는 배열
    private var startTime: StarTime = StarTime(hour: 00, minute: 00)
    private var endTime: StarTime = StarTime(hour: 23, minute: 59)
    
    init(mode: StarModalMode, refreshRelay: PublishRelay<Void>) {
        switch mode {
        case .create:
            print("")
        case .edit(let star):
            starRelay.accept(star)
            starName = star.title
            startTime = star.schedule.startTime
            endTime = star.schedule.endTime
//            weekDays = star.schedule.weekDays
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
        
        // 텍스트 필드 입력
        input.nameTextFieldInput
            .withUnretained(self)
            .subscribe(onNext: { owner, name in
                owner.starName = name
            })
            .disposed(by: disposeBag)
        
        // 텍스트필드 clear
        input.nameClear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.starName = ""
        }).disposed(by: disposeBag)
        
        // 선택한 요일(반복 주기)
        input.weekDaysState
            .withUnretained(self)
            .subscribe(onNext: { owner, daysState in
            if daysState.1 { owner.weekDays.insert(daysState.0) } else { owner.weekDays.remove(daysState.0) }
        }).disposed(by: disposeBag)
        
        // 시작 시간
        input.startTimeRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.startTime = StarTime(date: date)
            }).disposed(by: disposeBag)
        
        // 종료 시간
        input.endTimeRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.endTime = StarTime(date: date)
            }).disposed(by: disposeBag)
        
        // 스타 생성/수정
        input.addStarTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            
            // 이름 확인
            guard owner.starName != "" else {
                owner.starModalInputStateRelay.accept(.noName)
                return
            }
            
            // 반복 주기(요일 선택) 확인
            if owner.weekDays.isEmpty {
                owner.starModalInputStateRelay.accept(.noSchedule)
                return
            }
            
            // 시작시간이 종료시간보다 이른지 확인
//            if owner.startTime.hour > endTime.hour ||
//                (startTime.hour == endTime.hour && startTime.minute >= endTime.minute) {
//                self?.starModalInputStateRelay.accept(.overFinishTime)
//                return
//            }
            
            // 스타 UPDATE
            if let starRelay = owner.starRelay.value {
                let star = Star(identifier: starRelay.identifier,
                                title: starRelay.title,
                                blockList: .init(),
                                schedule: starRelay.schedule)
                owner.starManager.update(star)
                
                // 이름 확인
                if owner.starName == "" {
                    owner.starModalInputStateRelay.accept(.noName)
                    return
                }
                
                // 반복 주기(요일 선택) 확인
                if owner.weekDays.isEmpty {
                    owner.starModalInputStateRelay.accept(.noSchedule)
                    return
                }
                
                // 시작시간이 종료시간보다 이른지 확인
                if owner.startTime.hour > owner.endTime.hour ||
                    (owner.startTime.hour == owner.endTime.hour &&
                     owner.startTime.minute >= owner.endTime.minute) {
                    
                    owner.starModalInputStateRelay.accept(.overFinishTime)
                    
                    return
                }
                
                // UPDATE
                if let star = owner.starRelay.value {
                    
                    let star = Star(identifier: star.identifier,
                                    title: owner.starName,
                                    blockList: [],
                                    schedule: Schedule(startTime: owner.startTime,
                                                       finishTime: owner.endTime,
                                                       weekDays: owner.weekDays))
                    
                    owner.starManager.update(star)

                // CREATE
                } else {
                   
                    let star = Star(identifier: UUID(),
                                    title: owner.starName,
                                    blockList: [],
                                    schedule: Schedule(startTime: owner.startTime,
                                                       finishTime: owner.endTime,
                                                       weekDays: owner.weekDays))

                    owner.starManager.create(star)
                }
                
                owner.closeAlert()
                
            }).disposed(by: disposeBag)
        
        return Output(result: addStarResultRelay.asDriver(onErrorJustReturn: "에러 발생"),
                      star: starRelay.asDriver(onErrorDriveWith: .empty()),
                      starModalInputState: starModalInputStateRelay.asDriver(onErrorDriveWith: .empty()),
                      refresh: refreshRelay.asDriver(onErrorDriveWith: .empty()),
                      weekDaysRelay: weekDaysRelay.asDriver(onErrorDriveWith: .empty()))
    }
    
    // 종료 방출
    private func closeAlert() {
        refreshRelay.accept(())
    }
    
}

extension StarModalViewModel {
    
    struct Input {
        let nameTextFieldInput: Observable<String>
        let nameClear: Observable<Void>
        let startTimeRelay: Observable<Date>
        let endTimeRelay: Observable<Date>
        let addStarTap: Observable<Void>
        let weekDaysState: Observable<(WeekDay, Bool)>
    }
    
    struct Output {
        let result: Driver<String>
        let star: Driver<Star?>
        let starModalInputState: Driver<StarModalInputState>
        let refresh: Driver<Void>
        let weekDaysRelay: Driver<Set<WeekDay>>
    }
    
}

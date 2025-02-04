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
    
    private let coreData = CoreDataManager.shared
    private let starManager = StarManager.shared
    
    private let mondayRelay = BehaviorRelay<Bool>(value: false)
    private let tuesdayRelay = BehaviorRelay<Bool>(value: false)
    private let wednesdayRelay = BehaviorRelay<Bool>(value: false)
    private let thursdayRelay = BehaviorRelay<Bool>(value: false)
    private let fridayRelay = BehaviorRelay<Bool>(value: false)
    private let saturdayRelay = BehaviorRelay<Bool>(value: false)
    private let sundayRelay = BehaviorRelay<Bool>(value: false)

    private let addStarResultRelay = PublishRelay<String>()

    private let starRelay = BehaviorRelay<Star?>(value: nil)
    private let starModalInputStateRelay = PublishRelay<StarModalInputState>()
    private let refreshRelay: PublishRelay<Void>

    private let disposeBag = DisposeBag()
    
    private var starName = ""
    private var weekDays: [WeekDay] = [] // 선택 요일(반복 주기) 담는 배열
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
            endTime = star.schedule.finishTime
//            weekDays = star.schedule.weekDays
        }
        self.refreshRelay = refreshRelay
    }
    
    func transform(input: Input) -> Output {
        
        input.nameTextFieldInput.withUnretained(self).subscribe(onNext: { owner, name in
            owner.starName = name
        }).disposed(by: disposeBag)
        
        // 선택한 요일(반복 주기)
        input.mondayTapped.withLatestFrom(mondayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                if state {
                    self?.weekDays.append(.mon)
                } else {
                    if let index = self?.weekDays.firstIndex(of: .mon) {
                        self?.weekDays.remove(at: index)
                    }
                }
            })
            .bind(to: mondayRelay).disposed(by: disposeBag)
        
        input.tuesdayTapped.withLatestFrom(tuesdayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                if state {
                    self?.weekDays.append(.tue)
                } else {
                    if let index = self?.weekDays.firstIndex(of: .tue) {
                        self?.weekDays.remove(at: index)
                    }
                }
            })
            .bind(to: tuesdayRelay).disposed(by: disposeBag)
        
        input.wednesdayTapped.withLatestFrom(wednesdayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                if state {
                    self?.weekDays.append(.wed)
                } else {
                    if let index = self?.weekDays.firstIndex(of: .wed) {
                        self?.weekDays.remove(at: index)
                    }
                }
            })
            .bind(to: wednesdayRelay).disposed(by: disposeBag)
        
        input.thursdayTapped.withLatestFrom(thursdayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                if state {
                    self?.weekDays.append(.thu)
                } else {
                    if let index = self?.weekDays.firstIndex(of: .thu) {
                        self?.weekDays.remove(at: index)
                    }
                }
            })
            .bind(to: thursdayRelay).disposed(by: disposeBag)
        
        input.fridayTapped.withLatestFrom(fridayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                if state {
                    self?.weekDays.append(.fri)
                } else {
                    if let index = self?.weekDays.firstIndex(of: .fri) {
                        self?.weekDays.remove(at: index)
                    }
                }
            })
            .bind(to: fridayRelay).disposed(by: disposeBag)
        
        input.saturdayTapped.withLatestFrom(saturdayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                if state {
                    self?.weekDays.append(.sat)
                } else {
                    if let index = self?.weekDays.firstIndex(of: .sat) {
                        self?.weekDays.remove(at: index)
                    }
                }
            })
            .bind(to: saturdayRelay).disposed(by: disposeBag)
        
        input.sundayTapped.withLatestFrom(sundayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                if state {
                    self?.weekDays.append(.sun)
                } else {
                    if let index = self?.weekDays.firstIndex(of: .sun) {
                        self?.weekDays.remove(at: index)
                    }
                }
            })
            .bind(to: sundayRelay).disposed(by: disposeBag)
        
        
        input.startTimeSubject.withUnretained(self).subscribe(onNext: { owner, time in
//            owner.startTime = time
        }).disposed(by: disposeBag)
        
        input.endTimeSubject.withUnretained(self).subscribe(onNext: { owner, time in
//            owner.endTime = time
        }).disposed(by: disposeBag)
        
        input.addStarTap.withUnretained(self).subscribe(onNext: { owner, _ in
            
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
                let star = Star(identifier: starRelay.identifier, title: starRelay.title, blockList: [], schedule: starRelay.schedule)
                owner.starManager.update(star)
                
            // 스타 CREATE
            } else {
//                let star = Star(identifier: UUID(), title: owner.starName, blockList: [], schedule: Schedule(startTime: owner.startTime, finishTime: owner.endTime, weekDays: Set(WeekDay.allCases)))
//                owner.starManager.create(star)
            }

            owner.closeAlert()
            
        }).disposed(by: disposeBag)
        
        return Output(result: addStarResultRelay.asDriver(onErrorJustReturn: "에러 발생"), star: starRelay.asDriver(onErrorDriveWith: .empty()),
                      starModalInputState: starModalInputStateRelay.asDriver(onErrorDriveWith: .empty()),
                      refresh: refreshRelay.asDriver(onErrorDriveWith: .empty()))
    }
    
    // 종료 방출
    private func closeAlert() {
        refreshRelay.accept(())
    }
    
}

extension StarModalViewModel {
    
    struct Input {
        let nameTextFieldInput: Observable<String>
        let mondayTapped: Observable<Void>
        let tuesdayTapped: Observable<Void>
        let wednesdayTapped: Observable<Void>
        let thursdayTapped: Observable<Void>
        let fridayTapped: Observable<Void>
        let saturdayTapped: Observable<Void>
        let sundayTapped: Observable<Void>
        let startTimeSubject: Observable<String>
        let endTimeSubject: Observable<String>
        let addStarTap: Observable<Void>
    }
    
    struct Output {
        let result: Driver<String>
        let star: Driver<Star?>
        let starModalInputState: Driver<StarModalInputState>
        let refresh: Driver<Void>
    }
    
}

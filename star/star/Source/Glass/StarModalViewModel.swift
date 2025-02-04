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
    
    private var weekdays: [WeekDay] = []
    
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
        
        input.nameTextFieldInput.subscribe(onNext: { name in
            print(name)
        }).disposed(by: disposeBag)
        
        // 요일 버튼
        input.mondayTapped.withLatestFrom(mondayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                print("월 : \(state)")
                if state {
                    self?.weekdays.append(.mon)
                } else {
                    if let index = self?.weekdays.firstIndex(of: .mon) {
                        self?.weekdays.remove(at: index)
                    }
                }
                print("weekdays: \(self?.weekdays)")

            })
            .bind(to: mondayRelay).disposed(by: disposeBag)
        
        input.tuesdayTapped.withLatestFrom(tuesdayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                print("화 : \(state)")
                if state {
                    self?.weekdays.append(.tue)
                } else {
                    if let index = self?.weekdays.firstIndex(of: .tue) {
                        self?.weekdays.remove(at: index)
                    }
                }
                print("weekdays: \(self?.weekdays)")
            })
            .bind(to: tuesdayRelay).disposed(by: disposeBag)
        
        input.wednesdayTapped.withLatestFrom(wednesdayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                print("수 : \(state)")
                if state {
                    self?.weekdays.append(.wed)
                } else {
                    if let index = self?.weekdays.firstIndex(of: .wed) {
                        self?.weekdays.remove(at: index)
                    }
                }
                print("weekdays: \(self?.weekdays)")
            })
            .bind(to: wednesdayRelay).disposed(by: disposeBag)
        
        
        input.thursdayTapped.withLatestFrom(thursdayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                print("목 : \(state)")
                if state {
                    self?.weekdays.append(.thu)
                } else {
                    if let index = self?.weekdays.firstIndex(of: .thu) {
                        self?.weekdays.remove(at: index)
                    }
                }
                print("weekdays: \(self?.weekdays)")
            })
            .bind(to: thursdayRelay).disposed(by: disposeBag)
        
        
        input.fridayTapped.withLatestFrom(fridayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                print("금 : \(state)")
                if state {
                    self?.weekdays.append(.fri)
                } else {
                    if let index = self?.weekdays.firstIndex(of: .fri) {
                        self?.weekdays.remove(at: index)
                    }
                }
                print("weekdays: \(self?.weekdays)")
            })
            .bind(to: fridayRelay).disposed(by: disposeBag)
        
        
        input.saturdayTapped.withLatestFrom(saturdayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                print("토 : \(state)")
                if state {
                    self?.weekdays.append(.sat)
                } else {
                    if let index = self?.weekdays.firstIndex(of: .sat) {
                        self?.weekdays.remove(at: index)
                    }
                }
                print("weekdays: \(self?.weekdays)")
            })
            .bind(to: saturdayRelay).disposed(by: disposeBag)
        
        
        input.sundayTapped.withLatestFrom(sundayRelay)
            .map { !$0 }
            .do(onNext: { [weak self] state in
                print("일 : \(state)")
                if state {
                    self?.weekdays.append(.sun)
                } else {
                    if let index = self?.weekdays.firstIndex(of: .sun) {
                        self?.weekdays.remove(at: index)
                    }
                }
                print("weekdays: \(self?.weekdays)")
            })
            .bind(to: sundayRelay).disposed(by: disposeBag)
        
        
        input.startTimeSubject.subscribe(onNext: { time in
            print(time)
        }).disposed(by: disposeBag)
        
        input.endTimeSubject.subscribe(onNext: { time in
            print(time)
        }).disposed(by: disposeBag)
        
        input.addStarTap.subscribe(onNext: {
//            print(input.startTime)
        }).disposed(by: disposeBag)
        
        
        /*
        // 스타 생성하기(더미데이터) TODO: 실제 데이터로 수정
        input.addStarTap.withLatestFrom(Observable.combineLatest(
            input.nameTextFieldInput
        )).subscribe(onNext: { [weak self] name in
            // 이름 확인
            guard name != "" else {
                self?.starModalInputStateRelay.accept(.noName)
                return
            }
            
            print("name: \(name)")
            
            // 반복주기 확인
            if ((self?.weekDays.isEmpty) != nil) {
                self?.starModalInputStateRelay.accept(.noSchedule)
                return
            }
            
            // 시작시간이 종료시간보다 이른지 확인
//            if startTime.hour > endTime.hour ||
//                (startTime.hour == endTime.hour && startTime.minute >= endTime.minute) {
//                self?.starModalInputStateRelay.accept(.overFinishTime)
//                return
//            }

            if let starRelay = self?.starRelay.value {
//                let star = Star(identifier: starRelay.identifier, title: name, blockList: [], schedule: Schedule(startTime: startTime, finishTime: endTime, weekDays: Set(WeekDay.allCases)))
//                self?.starManager.update(star)
            } else {
//                let star = Star(identifier: UUID(), title: name, blockList: [], schedule: Schedule(startTime: startTime, finishTime: endTime, weekDays: Set(WeekDay.allCases)))
//                self?.starManager.create(star)
            }

            self?.closeAlert()
        }).disposed(by: disposeBag)
         */
                                                     
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

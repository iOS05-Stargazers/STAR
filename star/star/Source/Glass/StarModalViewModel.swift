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
    
    private let starManager = StarManager.shared
    private let scheduleVM: ScheduleVM
    
    private let nameTextFieldRelay = BehaviorRelay<String>(value: "")
//    private let appLockRelay = PublishRelay<[AppID]>
//    private let weekButtonsRelay = PublishRelay
    private let startTimeRelay = BehaviorRelay<StarTime>(value: StarTime(hour: 00, minute: 00))
    private let endTimeRelay = BehaviorRelay<StarTime>(value: StarTime(hour: 23, minute: 59))
    private let addStarResultRelay = PublishRelay<String>()

    private let disposeBag = DisposeBag()
    
    init(scheduleVM: ScheduleVM = ScheduleVM()) {
        self.scheduleVM = scheduleVM
    }
    
    func transform(input: Input) -> Output {
        // "HH:mm" 형식의 문자열을 Date로 변환하기 위한 DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        // 1. 이름 입력값을 ScheduleVM에 업데이트
        input.nameTextFieldInput
            .subscribe(onNext: { [weak self] name in
                self?.scheduleVM.updateName(name)
            })
            .disposed(by: disposeBag)
        
        // 2. 시작 시간 문자열을 Date로 변환하여 ScheduleVM 업데이트
        input.startTimePick
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] startTimeString in
                if let date = dateFormatter.date(from: startTimeString) {
                    self?.scheduleVM.updateStartTime(date)
                } else {
                    // 변환에 실패하면 기본값(Date())를 사용하거나 별도 처리 가능
                    self?.scheduleVM.updateStartTime(Date())
                }
            })
            .disposed(by: disposeBag)
        
        // 3. 종료 시간 문자열을 Date로 변환하여 ScheduleVM 업데이트
        input.endTimePick
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] endTimeString in
                if let date = dateFormatter.date(from: endTimeString) {
                    self?.scheduleVM.updateEndTime(date)
                } else {
                    // 변환에 실패하면 기본값(Date()+60분)을 사용하거나 별도 처리 가능
                    self?.scheduleVM.updateEndTime(Date().addingTimeInterval(3600))
                }
            })
            .disposed(by: disposeBag)
        
        // 4. "생성하기" 버튼 탭 시 스케줄 저장 후, scheduleVM에 저장된 스케줄을 사용하여 Star 생성
        input.addStarTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                // 스케줄을 저장(예: AppStorage에 기록하거나 DeviceActivityManager로 전달)
                self.scheduleVM.saveSchedule()
                // ScheduleVM 내부의 schedule 프로퍼티를 이용하여 Star 생성
                let schedule = self.scheduleVM.schedule
                let star = Star(identifier: UUID(), schedule: schedule)
                self.starManager.create(star)
                self.addStarResultRelay.accept("스타 생성 완료")
            })
            .disposed(by: disposeBag)
        
        return Output(result: addStarResultRelay.asDriver(onErrorJustReturn: "에러 발생"))
    }
    
}

extension StarModalViewModel {
    
    struct Input {
        let nameTextFieldInput: Observable<String>
//        let appLockButtonTap: Observable<Void>
//        let weekButtonsTap: Observable<Void>
        let startTimePick: Observable<String?>
        let endTimePick: Observable<String?>
        let addStarTap: Observable<Void>
    }
    
    struct Output {
        let result: Driver<String>
    }
    
}

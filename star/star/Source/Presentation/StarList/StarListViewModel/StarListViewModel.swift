//
//  StarListViewModel.swift
//  star
//
//  Created by 서문가은 on 1/26/25.
//

import Foundation
import RxSwift
import RxCocoa

enum StarModalState {
    
    case onboarding
    case create
    case edit(star: Star)
    case delete(star: Star)
    case delay
    case restSetting
    case resting
}

enum Unavailable {
    
    case createUnavailable
    case restUnavailable
    
    var message: String {
        switch self {
        case .createUnavailable:
            return "최대 15개의 스타를 저장할 수 있어요."
        case .restUnavailable:
            return "휴식할 수 있는 스타가 없어요."
        }
    }
}

// 셀 뷰모델
final class StarListViewModel {
    
    private let starsRelay = BehaviorRelay<[Star]>(value: [])
    private let dateRelay = PublishRelay<Date>()
    private let starStatusRelay = PublishRelay<StarState>()
    private let selectedStarRelay = PublishRelay<Star>() // 삭제 버튼 누르면 방출
    private let starModalStateRelay = PublishRelay<StarModalState>()
    let refreshRelay = PublishRelay<Void>()
    let delayCompleteRelay = PublishRelay<DelayMode>()
    let restSettingCompleteRelay = PublishRelay<Date>()
    private let unavailabilityRelay = PublishRelay<Unavailable>()
    private let disposeBag = DisposeBag()
    
    // 어떤 모달 띄워줄 지 확인하는 메서드
    private func checkModalState() {
        if !UserDefaults.standard.isCoachMarkShown {
            starModalStateRelay.accept(.onboarding)
        } else {
            fetchData()
            guard let restEndTime = UserDefaults.appGroups.restEndTimeGet(),
                  Date() < restEndTime else { return }
            starModalStateRelay.accept(.resting)
        }
    }
    
    // 삭제 버튼 누르면 스타 방출
    private func emitSelectedStar(_ index: Int) {
        let stars = starsRelay.value
        selectedStarRelay.accept(stars[index])
    }
    
    // 데이터 fetch
    private func fetchData() {
        fetchStars()
        fetchDate()
    }
    
    // 스타 fetch
    private func fetchStars() {
        let starData = StarManager.shared.read()
        
        guard let firstData = starData.first else {
            starsRelay.accept([])
            return
        }
        var minTimeStar = firstData.state().interval
        starData.forEach {
            // 남은 시간이 가장 임박한 star 저장
            if $0.state().interval < minTimeStar {
                minTimeStar = $0.state().interval
            }
        }
        
        scheduleStarFetch(minTimeStar)
        
        let sortedData = starData.sorted { $0.state() < $1.state() } // 남은 시간이 짧은 순으로 정렬
        starsRelay.accept(sortedData)
    }
    
    // 날짜 fetch
    private func fetchDate() {
        dateRelay.accept(Date.now)
        
        let timeLeft = TimeUntilMidnight.timeUntilMidnight()
        guard let timeLeft = timeLeft else { return }
        
        // 다음 날이 되면 date fetch
        Timer.scheduledTimer(withTimeInterval: timeLeft, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.fetchDate()
        }
    }
    
    // 일정 시간이 지나면 스타 데이터를 다시 가져오는 메서드
    private func scheduleStarFetch(_ minTimeStar: TimeInterval) {
        Timer.scheduledTimer(withTimeInterval: minTimeStar, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.fetchStars()
        }
    }
    
    // 생성 가능 여부 업데이트
    private func updateCreationAvailability() {
        if starsRelay.value.count > 14 {
            unavailabilityRelay.accept(.createUnavailable)
        } else {
            starModalStateRelay.accept(.create)
        }
    }
    
    // 휴식 가능 여부 업데이트
    private func updateRestionAvailability() {
        if starsRelay.value.isEmpty {
            unavailabilityRelay.accept(.restUnavailable)
        } else {
            starModalStateRelay.accept(.resting)
        }
    }
}

extension StarListViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let addButtonTapped: Observable<Void>
        let restButtonTapped: Observable<Void>
        let deleteAction: PublishSubject<Int>
    }
    
    struct Output {
        let starDataSource: Driver<[Star]>
        let date: Driver<Date>
        let star: Driver<Star>
        let starModalState: Driver<StarModalState>
        let unavailability: Driver<Unavailable>
    }
    
    func transform(_ input: Input) -> Output {
        refreshRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetchStars()
            })
            .disposed(by: disposeBag)
        
        delayCompleteRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, mode in
                
                switch mode {
                case .rest:
                    owner.starModalStateRelay.accept(.restSetting)
                case .edit(let star):
                    owner.starModalStateRelay.accept(.edit(star: star))
                case .delete(let star):
                    owner.starModalStateRelay.accept(.delete(star: star))
                }
            })
            .disposed(by: disposeBag)
        
        restSettingCompleteRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.starModalStateRelay.accept(.resting)
            })
            .disposed(by: disposeBag)
        
        input.deleteAction
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                owner.emitSelectedStar(index)
            }).disposed(by: disposeBag)
        
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext:  { owner, _ in
                owner.checkModalState()
            }).disposed(by: disposeBag)
        
        input.addButtonTapped
            .withUnretained(self)
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, _ in
                owner.updateCreationAvailability()
            }).disposed(by: disposeBag)
        
        input.restButtonTapped
            .withUnretained(self)
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, _ in
                HapticManager.shared.play(style: .selection)
                owner.updateRestionAvailability()
            }).disposed(by: disposeBag)
        
        return Output(
            starDataSource: starsRelay.asDriver(onErrorJustReturn: []),
            date: dateRelay.asDriver(onErrorDriveWith: .empty()),
            star: selectedStarRelay.asDriver(onErrorDriveWith: .empty()),
            starModalState: starModalStateRelay.asDriver(onErrorDriveWith: .empty()),
            unavailability: unavailabilityRelay.asDriver(onErrorDriveWith: .empty())
        )
    }
}

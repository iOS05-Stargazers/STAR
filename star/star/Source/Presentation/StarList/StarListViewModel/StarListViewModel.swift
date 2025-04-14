//
//  StarListViewModel.swift
//  star
//
//  Created by 서문가은 on 1/26/25.
//

import Foundation
import RxSwift
import RxCocoa
import UserNotifications
import UIKit

enum StarModalState {
    
    case onboarding
    case create
    case edit(star: Star)
    case delete(star: Star)
    case delay(mode: DelayMode)
    case restSetting
    case resting
}

enum Unavailable {
    
    case createUnavailable
    case restUnavailable
    
    var message: String {
        switch self {
        case .createUnavailable:
            return "toast.warning.max_stars_reached".localized
        case .restUnavailable:
            return "toast.warning.no_available_break".localized
        }
    }
}

// 셀 뷰모델
final class StarListViewModel {
    
    private let starsRelay = BehaviorRelay<[Star]>(value: [])
    private let dateRelay = PublishRelay<Date>()
    private let starModalStateRelay = PublishRelay<StarModalState>()
    private let unavailabilityRelay = PublishRelay<Unavailable>()
    let refreshRelay = PublishRelay<Void>()
    let delayCompleteRelay = PublishRelay<DelayMode>()
    let restSettingCompleteRelay = PublishRelay<Date>()
    private let disposeBag = DisposeBag()
    
    // 어떤 모달 띄워줄 지 확인하는 메서드
    private func checkModalState() {
        if !UserDefaults.standard.isCoachMarkShown {
            starModalStateRelay.accept(.onboarding)
            fetchDate()
        } else {
            fetchData()
            guard let restEndTime = RestManager().restEndTimeGet(),
                  Date() < restEndTime else { return }
            starModalStateRelay.accept(.resting)
        }
    }
    
    // 삭제 버튼 누르면 스타 방출
    private func emitSelectedStar(_ index: Int) {
        let stars = starsRelay.value
        updateStarDeleteModalState(stars[index])
    }
    
    // 데이터 fetch
    private func fetchData() {
        fetchStars()
        fetchDate()
    }
    
    // 스타 fetch
    func fetchStars() {
        let starData = StarManager.shared.read()
        
        // TODO: 1.0.5 정도 되면 삭제 (shouldKeepNotification)
        
        // 알림을 삭제해야되는지 확인
        if !UserDefaults.standard.shouldKeepNotification {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            starData.forEach {
                NotificationManager().scheduleNotificaions(star: $0)
            }
            
            UserDefaults.standard.shouldKeepNotification = true
        }
        
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
        if starsRelay.value.count > 4 {
            unavailabilityRelay.accept(.createUnavailable)
        } else {
            starModalStateRelay.accept(.create)
        }
    }
    
    // 휴식 가능 여부 업데이트
    private func updateRestAvailability() {
        // 진행중인 스타가 있는지 확인
        if starsRelay.value.filter({ $0.state().style == .ongoing }).count == 0 {
            unavailabilityRelay.accept(.restUnavailable)
        } else {
            starModalStateRelay.accept(.delay(mode: .rest))
        }
    }
    
    // 스타 수정 분기 처리 (스타가 대기중이면 바로 수정, 진행중이면 딜레이 화면)
    private func updateStarEditModalState(_ star: Star) {
        if star.state().style == .pending {
            starModalStateRelay.accept(.edit(star: star))
        } else {
            starModalStateRelay.accept(.delay(mode: .edit(star: star)))
        }
    }
    
    // 스타 삭제 분기 처리 (스타가 대기중이면 바로 삭제, 진행중이면 딜레이 화면)
    private func updateStarDeleteModalState(_ star: Star) {
        if star.state().style == .pending {
            starModalStateRelay.accept(.delete(star: star))
        } else {
            starModalStateRelay.accept(.delay(mode: .delete(star: star)))
        }
    }
}

extension StarListViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let addButtonTapped: Observable<Void>
        let restButtonTapped: Observable<Void>
        let starSelected: Observable<Star>
        let deleteAction: PublishSubject<Int>
    }
    
    struct Output {
        let starDataSource: Driver<[Star]>
        let date: Driver<Date>
        let starModalState: Driver<StarModalState>
        let unavailability: Driver<Unavailable>
    }
    
    func transform(_ input: Input) -> Output {
        NotificationCenter.default.rx // foreground 전환 감지
            .notification(UIApplication.willEnterForegroundNotification)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetchData()
            })
            .disposed(by: disposeBag)
        
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
            .throttle(.seconds(3), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, _ in
                owner.updateCreationAvailability()
            }).disposed(by: disposeBag)
        
        input.restButtonTapped
            .withUnretained(self)
            .throttle(.seconds(3), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, _ in
                HapticManager.shared.play(style: .selection)
                owner.updateRestAvailability()
            }).disposed(by: disposeBag)
        
        input.starSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, star in
                owner.updateStarEditModalState(star)
            }).disposed(by: disposeBag)
                
        return Output(
            starDataSource: starsRelay.asDriver(onErrorJustReturn: []),
            date: dateRelay.asDriver(onErrorDriveWith: .empty()),
            starModalState: starModalStateRelay.asDriver(onErrorDriveWith: .empty()),
            unavailability: unavailabilityRelay.asDriver(onErrorDriveWith: .empty())
        )
    }
}

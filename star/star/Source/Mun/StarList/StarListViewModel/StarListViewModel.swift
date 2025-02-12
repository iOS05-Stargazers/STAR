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
    case restStart
    case restSetting
    case resting(date: Date)
}

 // 셀 뷰모델
final class StarListViewModel {
        
    private let starsRelay = BehaviorRelay<[Star]>(value: [])
    private let dateRelay = PublishRelay<Date>()
    private let starStatusRelay = PublishRelay<StarState>()
    private let selectedStarRelay = PublishRelay<Star>() // 삭제 버튼 누르면 방출
    private let starModalStateRelay = PublishRelay<StarModalState>()
    let refreshRelay = PublishRelay<Void>()
    let restStartCompleteRelay = PublishRelay<Void>()
    let restingCompleteRelay = PublishRelay<Date>()
    private let disposeBag = DisposeBag()
    
    // 어떤 모달 띄워줄 지 확인하는 메서드
    private func checkModalState() {
        if !UserDefaults.standard.isCoachMarkShown {
            starModalStateRelay.accept(.onboarding)
        } else {
            fetchData()
            guard let restEndTime = UserDefaults.standard.restEndTimeGet(),
            Date() < restEndTime else { return }
            starModalStateRelay.accept(.resting(date: restEndTime))
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
}

extension StarListViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let deleteAction: PublishSubject<Int>
    }
    
    struct Output {
        let starDataSource: Driver<[Star]>
        let date: Driver<Date>
        let star: Driver<Star>
        let starModalState: Driver<StarModalState>
    }
    
    func transform(_ input: Input) -> Output {
        refreshRelay
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.fetchStars()
            })
            .disposed(by: disposeBag)
        
        restStartCompleteRelay
            .subscribe(onNext: {
                self.starModalStateRelay.accept(.restSetting)
            })
            .disposed(by: disposeBag)

        restingCompleteRelay
            .subscribe(onNext: { date in
                self.starModalStateRelay.accept(.resting(date: date))
            })
            .disposed(by: disposeBag)
        
        input.deleteAction
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                self.emitSelectedStar(index)
            }).disposed(by: disposeBag)
        
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext:  { _ in
                self.checkModalState()
            }).disposed(by: disposeBag)
        
        return Output(starDataSource: starsRelay.asDriver(onErrorJustReturn: []),
                      date: dateRelay.asDriver(onErrorDriveWith: .empty()),
                      star: selectedStarRelay.asDriver(onErrorDriveWith: .empty()),
                      starModalState: starModalStateRelay.asDriver(onErrorDriveWith: .empty()))
    }
}

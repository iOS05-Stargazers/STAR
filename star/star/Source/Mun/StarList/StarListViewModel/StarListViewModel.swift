//
//  StarListViewModel.swift
//  star
//
//  Created by 서문가은 on 1/26/25.
//

import Foundation
import RxSwift
import RxCocoa

enum CreationAvailability {
    case available
    case unavailable
    
    var text: String? {
        switch self {
        case .available:
            return nil
        case .unavailable:
            return "최대 15개의 스타를 저장할 수 있어요."
        }
    }
}
 
 // 셀 뷰모델   
final class StarListViewModel {
        
    private let starsRelay = BehaviorRelay<[Star]>(value: [])
    private let dateRelay = PublishRelay<Date>()
    private let starStatusRelay = PublishRelay<StarState>()
    private let selectedStarRelay = PublishRelay<Star>() // 삭제 버튼 누르면 방출
    private let creationAvailabilityRelay = PublishRelay<CreationAvailability>()
    let refreshRelay = PublishRelay<Void>() // 추후 리팩토링 예정
    private let disposeBag = DisposeBag()

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
                
        // 남은 시간이 0이 되면 데이터 fetch
        Timer.scheduledTimer(withTimeInterval: minTimeStar, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.fetchStars()
        }
        
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
    
    // 삭제 버튼 누르면 스타 방출
    private func emitSelectedStar(_ index: Int) {
        let stars = starsRelay.value
        selectedStarRelay.accept(stars[index])
    }
    
    // 생성 가능 여부 업데이트
    private func updateCreationAvailability() {
        let result: CreationAvailability = starsRelay.value.count > 14 ? .unavailable : .available
        creationAvailabilityRelay.accept(result)
    }
}

extension StarListViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let addButtonTapped: Observable<Void>
        let deleteAction: PublishSubject<Int>
    }
    
    struct Output {
        let starDataSource: Driver<[Star]>
        let date: Driver<Date>
        let star: Driver<Star>
        let creationAvailability: Driver<CreationAvailability>
    }
    
    func transform(_ input: Input) -> Output {
        refreshRelay
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.fetchStars()
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
                self.fetchStars()
                self.fetchDate()
            }).disposed(by: disposeBag)
        
        input.addButtonTapped
            .withUnretained(self)
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                self.updateCreationAvailability()
            }).disposed(by: disposeBag)
        
        return Output(starDataSource: starsRelay.asDriver(onErrorJustReturn: []),
                      date: dateRelay.asDriver(onErrorDriveWith: .empty()),
                      star: selectedStarRelay.asDriver(onErrorDriveWith: .empty()),
                      creationAvailability: creationAvailabilityRelay.asDriver(onErrorDriveWith: .empty()))
    }
}

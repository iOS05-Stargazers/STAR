//
//  StarListViewModel.swift
//  star
//
//  Created by 서문가은 on 1/26/25.
//

import Foundation
import RxSwift
import RxCocoa
 
 // 셀 뷰모델   
class StarListViewModel {
        
    private let starsRelay = BehaviorRelay<[Star]>(value: [])
    private let dateRelay = PublishRelay<Date>()
    private let starStatus = PublishRelay<StarState>()
    private let disposeBag = DisposeBag()

    // 스타 fetch
    private func fetchStars() {
        let testData = [MockData.ongingOneHour, MockData.ongingThreeHour, MockData.pendingOneMinute, MockData.pendingTenMinute] // 추후 CoreData로 연동
        
        guard let firstData = testData.first else { return }
        var minTimeStar = firstData.state().interval
        testData.forEach {
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
        
        let sortedData = testData.sorted { $0.state() < $1.state() } // 남은 시간이 짧은 순으로 정렬
        starsRelay.accept(sortedData)
    }
    
    // 날짜 fetch
    private func fetchDate() {
        dateRelay.accept(Date.now)
    }
}

extension StarListViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let starDataSource: Driver<[Star]>
        let date: Driver<Date>
    }
    
    func transform(_ input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext:  { _ in
                self.fetchStars()
                self.fetchDate()
            }).disposed(by: disposeBag)
        
        return Output(starDataSource: starsRelay.asDriver(onErrorJustReturn: []),
                      date: dateRelay.asDriver(onErrorDriveWith: .empty()))
    }
}



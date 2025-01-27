//
//  StarListViewModel.swift
//  star
//
//  Created by 서문가은 on 1/26/25.
//

import Foundation
import RxSwift
import RxCocoa
 
class StarListViewModel {
        
    private let starsRelay = BehaviorRelay<[Star]>(value: [])
    private let dateRelay = PublishRelay<Date>()
    private let disposeBag = DisposeBag()

    // 스타 fetch
    private func fetchStars() {
        let testData = [MockData.star1, MockData.star2]
        starsRelay.accept(testData)
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



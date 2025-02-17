//
//  OnboardingViewModel.swift
//  star
//
//  Created by Eden on 2/16/25.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let skipTapped: Observable<Void>
        let pageChanged: Observable<Int>
    }
    
    struct Output {
        let skipTrigger: Driver<Void>
        let currentPage: Driver<Int>
    }
    
    let pages: [OnboardingModel] = [
        OnboardingModel(
            image: UIImage(named: "onboardingCreateImage"),
            description: "\"스타 추가하기\"를 통해\n스타를 생성할 수 있습니다."
        ),
        OnboardingModel(
            image: UIImage(named: "onboardingModifyImage"),
            description: "목록의 스타를 선택하면\n스타를 수정할 수 있습니다."
        ),
        OnboardingModel(
            image: UIImage(named: "onboardingDeleteImage"),
            description: "왼쪽으로 스와이프하여\n스타를 삭제할 수 있습니다."
        ),
        OnboardingModel(
            image: UIImage(named: "onboardingRestImage"),
            description: "휴식 버튼을 누르면\n휴식 모드로 전환할 수 있습니다."
        )
    ]
    
    let currentPage = BehaviorRelay<Int>(value: 0) // 초기 페이지 0
    private let skipRelay = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        input.pageChanged
            .withUnretained(self)
            .bind { owner, page in
                owner.currentPage.accept(page)
            }
            .disposed(by: disposeBag)

        input.skipTapped
            .withUnretained(self)
            .bind { owner, _ in
                owner.skipRelay.accept(())
            }
            .disposed(by: disposeBag)

        return Output(
            skipTrigger: skipRelay.asDriver(onErrorDriveWith: .empty()),
            currentPage: currentPage.asDriver()
        )
    }
}

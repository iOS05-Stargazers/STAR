//
//  OnboardingViewModel.swift
//  star
//
//  Created by Eden on 2/16/25.
//

import UIKit.UIImage
import RxSwift
import RxCocoa

struct OnboardingModel {
    
    let image: UIImage // 목업 이미지
    let description: String // 온보딩 설명 문구
}

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
    
    let pages = BehaviorRelay<[OnboardingModel]>(value: [
        OnboardingModel(
            image: UIImage.onboardingCreate,
            description: "onboarding.create".localized
        ),
        OnboardingModel(
            image: UIImage.onboardingModify,
            description: "onboarding.edit".localized
        ),
        OnboardingModel(
            image: UIImage.onboardingDelete,
            description: "onboarding.delete".localized
        )
    ])
    
    let currentPage = BehaviorRelay<Int>(value: 0) // 초기 페이지 0
    let skipRelay = PublishRelay<Void>()
    
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

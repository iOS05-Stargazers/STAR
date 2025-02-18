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
            description: "\"스타 추가하기\"를 통해\n스타를 생성할 수 있습니다."
        ),
        OnboardingModel(
            image: UIImage.onboardingModify,
            description: "목록의 스타를 선택하면\n스타를 수정할 수 있습니다."
        ),
        OnboardingModel(
            image: UIImage.onboardingDelete,
            description: "왼쪽으로 스와이프하여\n스타를 삭제할 수 있습니다."
        ),
        OnboardingModel(
            image: UIImage.onboardingRest,
            description: "휴식 버튼을 누르면\n휴식 모드로 전환할 수 있습니다."
        )
    ])
    
    private let currentPage = BehaviorRelay<Int>(value: 0) // 초기 페이지 0
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

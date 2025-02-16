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
    
    let pages: [OnboardingModel] = [
        OnboardingModel(
            highlightElements: [UIImageView()],
            description: "스타 추가하기를 통해\n스타를 생성할 수 있어요."
        ),
        OnboardingModel(
            highlightElements: [UIImageView()],
            description: "스타를 선택해\n시간과 설정을 변경할 수 있어요."
        ),
        OnboardingModel(
            highlightElements: [UIImageView(), UIImageView()],
            description: "카드를 스와이프해\n스타를 삭제할 수 있어요."
        ),
        OnboardingModel(
            highlightElements: [UIImageView(), UIImageView()],
            description: "휴식 버튼을 눌러\n휴식시간을 설정하세요."
        )
    ]
    
    let currentPage = BehaviorRelay<Int>(value: 0) // 초기 페이지 0
}

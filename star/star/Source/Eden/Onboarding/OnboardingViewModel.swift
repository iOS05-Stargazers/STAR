//
//  OnboardingViewModel.swift
//  star
//
//  Created by Eden on 2/16/25.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class OnboardingViewModel {
    
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
    let closeEvent = PublishRelay<Void>() // 온보딩 닫기
}

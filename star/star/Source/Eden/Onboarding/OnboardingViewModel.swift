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
            highlightElements: [
                OnboardingHighlightElement(
                    image: UIImage(named: "starButtonImage"),
                    position: (xMultiplier: 0.5, yMultiplier: 1.2),
                    leadingInset: 20,
                    trailingInset: 20
                )
            ],
            description: "\"스타 추가하기\"를 통해\n스타를 생성할 수 있습니다."
        ),
        OnboardingModel(
            highlightElements: [
                OnboardingHighlightElement(
                    image: UIImage(named: "starCellImage"),
                    position: (xMultiplier: 0.5, yMultiplier: 0.75),
                    leadingInset: 20,
                    trailingInset: 20
                )
            ],
            description: "목록의 스타를 선택하면\n스타를 수정할 수 있습니다."
        ),
        OnboardingModel(
            highlightElements: [
                OnboardingHighlightElement(
                    image: UIImage(named: "starCellImage"),
                    position: (xMultiplier: 0.5, yMultiplier: 0.75),
                    leadingInset: 20,
                    trailingInset: 20
                ),
                OnboardingHighlightElement(
                    image: UIImage(systemName: "hand.draw.fill"),
                    position: (xMultiplier: 0.8, yMultiplier: 0.75),
                    leadingInset: 0,
                    trailingInset: 0
                )
            ],
            description: "왼쪽으로 스와이프하여\n스타를 삭제할 수 있습니다."
        ),
        OnboardingModel(
            highlightElements: [
                OnboardingHighlightElement(
                    image: UIImage(systemName: "hand.tap.fill"),
                    position: (xMultiplier: 0.85, yMultiplier: 0.32),
                    leadingInset: 0,
                    trailingInset: 0
                )
            ],
            description: "휴식 버튼을 누르면\n휴식 모드로 전환할 수 있습니다."
        )
    ]
    
    let currentPage = BehaviorRelay<Int>(value: 0) // 초기 페이지 0
}

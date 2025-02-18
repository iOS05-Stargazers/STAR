//
//  GradientButton.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-23.
//

import UIKit
import RxSwift

class GradientButton: UIButton, GradientApplicable {
    
    let gradientLayer = CAGradientLayer()
    private let disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutGradientLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 버튼 탭 시 진동
        self.rx.tap.subscribe(onNext: {
            HapticManager.shared.play(1, style: .impact(.heavy))
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

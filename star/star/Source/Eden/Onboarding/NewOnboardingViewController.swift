//
//  OnboardingViewController.swift
//  star
//
//  Created by Eden on 2/13/25.
//

import UIKit
import SnapKit
import Then

final class NewOnboardingViewController: UIViewController {
    
    private let bottomView = OnboardingCustomBottomView().then {
        $0.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomView()
    }
    
    private func setupBottomView() {
        view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(440)
        }
    }
}

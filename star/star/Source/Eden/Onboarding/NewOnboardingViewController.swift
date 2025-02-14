//
//  OnboardingViewController.swift
//  star
//
//  Created by Eden on 2/13/25.
//

import UIKit
import SnapKit
import Then

final class OnboardingViewController: UIViewController {
    
    private let onboardingCustomView = OnboardingCustomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(onboardingCustomView)
        
        onboardingCustomView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

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
    
    private let onboardingView = OnboardingCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(onboardingView)
        
        onboardingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

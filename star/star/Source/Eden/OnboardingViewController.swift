//
//  OnboradingViewController.swift
//  star
//
//  Created by Eden on 1/24/25.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let onboardingView = OnboardingView()
    
    override func loadView() {
        self.view = onboardingView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

//
//  OnboardingViewController.swift
//  star
//
//  Created by 0-jerry on 1/31/25.
//

import UIKit
import SnapKit
import Then

final class OnboardingViewController: UIViewController {

    override func loadView() {
        view = OnboardingView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    // 화면 터치 시 모달 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UserDefaults.standard.isCoachMarkShown = true
        dismiss(animated: false)
    }
}

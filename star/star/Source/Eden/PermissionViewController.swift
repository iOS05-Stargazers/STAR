//
//  OnboradingViewController.swift
//  star
//
//  Created by Eden on 1/24/25.
//

import UIKit

class PermissionViewController: UIViewController {
    
    private let permissionView = PermissionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = permissionView
        setupActions()
    }
    
    private func setupActions() {
        permissionView.denyButton.addTarget(self, action: #selector(navigateToStarList) , for: .touchUpInside)
        permissionView.allowButton.addTarget(self, action: #selector(allowButtonTapped), for: .touchUpInside)
        permissionView.learnMoreButton.addTarget(self, action: #selector(navigateToStarList) , for: .touchUpInside)
    }
    
    @objc
    func navigateToStarList() {
        let starListViewController = StarListViewController()
        navigationController?.pushViewController(starListViewController, animated: false)
    }
    
    // TODO: - 권한 설정 기능 구현
    
    @objc
    func allowButtonTapped() {
        print("계속")
    }
}

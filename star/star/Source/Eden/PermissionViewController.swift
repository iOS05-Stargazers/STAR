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
        permissionView.denyButton.addTarget(self, action: #selector(handleNavigationToStarList) , for: .touchUpInside)
        permissionView.learnMoreButton.addTarget(self, action: #selector(handleNavigationToStarList) , for: .touchUpInside)
    }
    
    @objc
    func handleNavigationToStarList() {
        let starListViewController = StarListViewController()
        navigationController?.pushViewController(starListViewController, animated: false)
    }
    
    // TODO: - 권한 설정 기능 구현
    
    @objc
    func allowButtonTapped() {
        print("계속")
    }
}

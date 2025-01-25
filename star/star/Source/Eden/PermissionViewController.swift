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
        permissionView.denyButton.addTarget(self, action: #selector(denyButtonTapped) , for: .touchUpInside)
        permissionView.learnMoreButton.addTarget(self, action: #selector(learnMoreButtonTapped) , for: .touchUpInside)
    }
    
    @objc
    func denyButtonTapped() {
        let starListViewController = StarListViewController()
        navigationController?.pushViewController(starListViewController, animated: false)    }
    
    @objc
    func allowButtonTapped() {
        print("계속")
    }
    
    @objc
    func learnMoreButtonTapped() {
        let starListViewController = StarListViewController()
        navigationController?.pushViewController(starListViewController, animated: false)
    }
}

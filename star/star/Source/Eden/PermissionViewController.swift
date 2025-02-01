//
//  PermissionViewController.swift
//  star
//
//  Created by Eden on 1/24/25.
//

import UIKit
import SnapKit

class PermissionViewController: UIViewController {
    
    private let permissionView = PermissionView()
    private let familyControlsManager = FamilyControlsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = permissionView
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func bind() {
        
    }
    
    @objc
    func navigateToStarList() {
        let starListViewController = StarListViewController()
        navigationController?.pushViewController(starListViewController, animated: false)
    }
}

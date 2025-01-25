//
//  OnboradingViewController.swift
//  star
//
//  Created by Eden on 1/24/25.
//

import UIKit

class PermissionViewController: UIViewController {
    
    private let permissionView = PermissionView()
    
    override func loadView() {
        self.view = permissionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

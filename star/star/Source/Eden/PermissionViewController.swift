//
//  OnboradingViewController.swift
//  star
//
//  Created by Eden on 1/24/25.
//

import UIKit
import SnapKit
import FamilyControls
import DeviceActivity

class PermissionViewController: UIViewController {
    
    private let permissionView = PermissionView()
    private let familyControlsManager = FamilyControlsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = permissionView
        /// 다크모드 강제 설정
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
            view.overrideUserInterfaceStyle = .dark
            navigationController?.overrideUserInterfaceStyle = .dark
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
        requestScreenTimePermission()
    }
    
    private func requestScreenTimePermission() {
        if #available(iOS 15.0, *) {
            /// iOS 16.0 이상에서 권한 요청
            familyControlsManager.requestAuthorization()
        } else {
            /// iOS 15 미만일 경우 처리
            print("이 기능은 iOS 15.0 이상에서만 지원됩니다.")
        }
    }
    
    @objc
    func navigateToStarList() {
        let starListViewController = StarListViewController()
        navigationController?.pushViewController(starListViewController, animated: false)
    }
}

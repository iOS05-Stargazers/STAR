//
//  PermissionViewController.swift
//  star
//
//  Created by Eden on 1/24/25.
//

/// From Maccha:
/// SceneDelegate와 ContentViewContainer에 SwiftUI를 도입하면서
/// 구조상 더 이상 사용하지/호환되지 않는 코드가 되어 주석 처리하였습니다.

/*
import UIKit
import SnapKit

class PermissionViewController: UIViewController {
    
    private let permissionView = PermissionView()
    private let familyControlsManager = FamilyControlsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = permissionView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
        requestScreenTimePermission()
    }
    
    /// 권한 설정 요청 메서드
    private func requestScreenTimePermission() {
        familyControlsManager.requestAuthorization { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToStarList()
            }
        }
    }
    
    @objc
    func navigateToStarList() {
        let starListViewController = StarListViewController()
        navigationController?.pushViewController(starListViewController, animated: false)
    }
}
*/

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
        /// 다크모드 강제 설정
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
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
            familyControlsManager.requestAuthorization(completionHandler: {
                DispatchQueue.main.async {
                    self.navigateToStarList()
                }
            })
        } else {
            /// iOS 15 미만일 경우 처리
            print("이 기능은 iOS 15.0 이상에서만 지원됩니다.")
            let alert = UIAlertController(
                title: "지원되지 않는 버전",
                message: "이 기능은 iOS 15.0 이상에서만 지원됩니다.\n최신 버전으로 업데이트해주세요.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.navigateToStarList()
            }))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc
    func navigateToStarList() {
        let starListViewController = StarListViewController()
        navigationController?.pushViewController(starListViewController, animated: false)
    }
}

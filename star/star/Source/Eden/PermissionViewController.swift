//
//  OnboradingViewController.swift
//  star
//
//  Created by Eden on 1/24/25.
//

import UIKit
import SnapKit

class PermissionViewController: UIViewController {
    
    private let permissionView = PermissionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = permissionView
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
        showPermissionSystemAlert()
    }
    
    private func setupActions() {
        permissionView.learnMoreButton.addTarget(self, action: #selector(navigateToStarList) , for: .touchUpInside)
    }
    
    @objc
    func navigateToStarList() {
        let starListViewController = StarListViewController()
        navigationController?.pushViewController(starListViewController, animated: false)
    }
    
    private func showPermissionSystemAlert() {
        let alert = UIAlertController(
            title: "'STAR' 앱이 스크린타임에 접근하려고 함",
            message: """
                    'STAR'에 스크린타임 접근을 허용하면,
                    이 앱이 사용자의 활동 데이터를 보고,
                    콘텐츠를 제한하며, 앱 및 웹사이트의
                    사용을 제한할 수도 있습니다.
                    """,
            preferredStyle: .alert
        )
        
        let denyAction = UIAlertAction(title: "허용 안 함", style: .cancel, handler: { _ in
            self.navigateToStarList()
        })
        alert.addAction(denyAction)
        
        let allowAction = UIAlertAction(title: "허용", style: .default, handler: { _ in
            print("허용")
        })
        alert.addAction(allowAction)
        
        alert.preferredAction = allowAction
        
        /// 다크모드
        if #available(iOS 13.0, *) {
            alert.overrideUserInterfaceStyle = .dark
        }
        
        present(alert, animated: true) {
            let alertHeight = alert.view.frame.height
            let alertCenterY = alert.view.frame.midY
            DispatchQueue.main.async {
                self.permissionView.updateAlertHighlightViewY(alertCenterY: alertCenterY, alertHeight: alertHeight)
            }
        }
    }
    
    // TODO: - 권한 설정 기능 구현
    
    @objc
    func allowButtonTapped() {
        print("계속")
    }
}

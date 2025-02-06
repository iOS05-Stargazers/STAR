//
//  ViewController.swift
//  test
//
//  Created by 0-jerry on 2/6/25.
//

import UIKit
import SnapKit
import FamilyControls

class SpaceViewController: UIViewController {
    
    private var starryNightView: StarryNightView!
    private var meteorEffectView: MeteorEffectView!
    
    // MARK: - UI Components
    
    // 로고 이미지
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "logo")
    }
    
    // 로고 타이틀 이미지
    private let logoTitleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "logoText")
    }
    
    // 타이틀 라벨
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "별을 이루는 당신의 시간, STAR와 함께 빛나세요"
        label.textColor = .white
        label.font = Fonts.modalSectionOption
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 생명주기 메서드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
    }
    
    // MARK: - 레이아웃 설정
    
    private func setupUI() {
        view.backgroundColor = .starAppBG
        
        starryNightView = StarryNightView(frame: view.bounds)
        meteorEffectView = MeteorEffectView(frame: view.bounds)
        
        [
            starryNightView,
            meteorEffectView,
            logoImageView,
            titleLabel,
            logoTitleImageView
        ].forEach {
            view.addSubview($0)
        }
        
        starryNightView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        meteorEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoTitleImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-70)
            $0.width.equalTo(70)
        }
        
        logoImageView.snp.makeConstraints {
            $0.trailing.equalTo(logoTitleImageView.snp.leading).offset(-20)
            $0.bottom.equalTo(logoTitleImageView.snp.top).offset(25)
            $0.width.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoTitleImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - 네비게이션 설정
    
    private func setupNavigation() {
        // 1초 뒤 실행
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            let center = AuthorizationCenter.shared
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1초 후 상태 확인
                   var rootViewController: UIViewController

                   if center.authorizationStatus == .approved {
                       // 권한이 승인된 상태 -> StarListViewController로 실행
                       rootViewController = StarListViewController()
                   } else {
                       // 권한 미승인 상태 -> PermissionViewController로 실행
                       rootViewController = PermissionViewController()
                   }
                   self.navigationController?.setViewControllers([rootViewController], animated: true)
               }
        }
    }
}

//
//  AppLaunchViewController.swift
//  test
//
//  Created by 0-jerry on 2/6/25.
//

import UIKit
import SnapKit
import FamilyControls

final class AppLaunchViewController: UIViewController {
    
    let galaxyView = GalaxyView()
    
    // MARK: - UI Components
    
    // 로고 이미지
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage.logo
    }
    
    // 로고 타이틀 이미지
    private let logoTitleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "logoText")
    }
    
    // 타이틀 라벨
    private lazy var titleLabel = UILabel().then {
        $0.text = "app.launch.message".localized
        $0.textColor = .white
        $0.font = UIFont.System.regular16
    }
    
    // MARK: - 생명주기 메서드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        addTwinklingStars() // 별 반짝이는 효과
    }
    
    // MARK: - 레이아웃 설정
    
    private func setupUI() {
        view.backgroundColor = .starAppBG
                
        [
            galaxyView,
            logoImageView,
            titleLabel,
            logoTitleImageView
        ].forEach {
            view.addSubview($0)
        }
        
        // 이미지 넣기
        if let image = UIImage(named: "cloudImage") {
            
            let cloudImageView = UIImageView(image: image)
            
            if let height = cloudImageView.image?.size.height, let width = cloudImageView.image?.size.width {
                cloudImageView.alpha = 0.2 // 투명도 조절
                view.addSubview(cloudImageView)
                
                cloudImageView.snp.makeConstraints {
                    $0.centerX.centerY.equalToSuperview()
                    $0.width.equalTo(width * 1.2)
                    $0.height.equalTo(height * 1.2)
                }
                
            }
        } else {
            print("이미지를 찾을 수 없습니다.")
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
    
    // MARK: - 별 효과
    
    func addTwinklingStars() {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.frame = view.bounds
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        emitterLayer.emitterSize = view.bounds.size
        
        let starCell = CAEmitterCell()
        starCell.contents = makeCircleImage().cgImage // 별 이미지 또는 기본 원
        starCell.birthRate = 15//5  // 별 생성 속도
        starCell.lifetime = 5//15.0  // 별이 사라지는 시간
        starCell.lifetimeRange = 1.5 // 수명 변동
        starCell.alphaSpeed = -0.1 // 투명도 변화 (반짝임 효과)
        starCell.velocity = 0 // 이동 속도
        starCell.velocityRange = 0 // 속도 변화
        starCell.scale = 0.05 // 기본 크기
        starCell.scaleRange = 0.03 // 크기 변동
        starCell.emissionRange = .pi * 2.0 // 360도 랜덤 생성
        
        emitterLayer.emitterCells = [starCell]
        view.layer.addSublayer(emitterLayer)
    }
    
    // 별 이미지가 없을 경우 기본 원형 이미지 생성
    func makeCircleImage() -> UIImage {
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}

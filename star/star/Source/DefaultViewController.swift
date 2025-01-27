//
//  DefaultViewController.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-21.
//
//  SceneDelegate에서 window.rootViewController의 기본값으로 잡혀있는 ViewController입니다.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class DefaultViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let bundle = Bundle()
    
    private let mainLogoLabel = UILabel().then {
        $0.text = "STAR"
        $0.font = Fonts.mainLogo
        $0.textColor = .starPrimaryText
    }
    
    private let addStarButton = GradientButton(type: .system).then {
        $0.setTitle("스타 추가하기", for: .normal)
        $0.setTitleColor(.starPrimaryText, for: .normal)
        $0.titleLabel?.font = Fonts.buttonTitle
        $0.backgroundColor = .starDisabledTagBG // 그라디언트가 정상적으로 적용될 시 배경색은 보이지 않음
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = .starAppBG
        
        [mainLogoLabel,
         addStarButton
        ].forEach { view.addSubview($0) }
        
        mainLogoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
        }
        
        addStarButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-150)
            make.height.equalTo(56)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // applyGradient는 버튼의 레이아웃 적용이 끝난 시점에서 호출해야 함
        addStarButton.applyGradient(colors: [.starButtonPurple, .starButtonNavy], direction: .horizontal)
    }
        
        private func setupBindings() {
            addStarButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    print("\(self?.bundle.appGroupName ?? "")")
                })
                .disposed(by: disposeBag)
        }
}


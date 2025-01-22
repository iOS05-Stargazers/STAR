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

class DefaultViewController: UIViewController {
    
    private let mainLogoLabel = UILabel().then {
        $0.text = "STAR"
        $0.font = Font.mainLogo
        $0.textColor = .starPrimaryText
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .starAppBG
        
        [mainLogoLabel
        ].forEach { view.addSubview($0) }
        
        mainLogoLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}


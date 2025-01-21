//
//  DefaultViewController.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-21.
//
//  SceneDelegate에서 window.rootViewController의 기본값으로 잡혀있는 ViewController입니다.
//

import UIKit

class DefaultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemPurple
    }
}


//
//  RestingViewController.swift
//  star
//
//  Created by Eden on 2/6/25.
//

import UIKit
import SnapKit
import Then

final class RestingViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "휴식중"
        $0.font = .boldSystemFont(ofSize: 32)
        $0.textColor = .starPrimaryText
    }
    
    private let timerLabel = UILabel().then {
        $0.text = "00:00:00"
        $0.font = .monospacedDigitSystemFont(ofSize: 32, weight: .bold)
        $0.textColor = .starSecondaryText
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Set Up
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        view.addSubviews(titleLabel, timerLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
}

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
        $0.textColor = .starSecondaryText
    }
    
    private let timerLabel = UILabel().then {
        $0.text = "00:00:00"
        $0.font = .monospacedDigitSystemFont(ofSize: 32, weight: .bold)
        $0.textColor = .starSecondaryText
    }
    
    private let endRestButton = GradientButton().then {
        $0.setTitle("휴식 종료하기", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
        $0.setTitleColor(.starTertiaryText, for: .normal)
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        
        $0.applyGradient(colors: [.starButtonWhite, .starButtonYellow], direction: .horizontal)
    }

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Set Up
    
    private func setupUI() {
        view.backgroundColor = .starModalOverlayBG
        
        view.addSubviews(titleLabel, timerLabel, endRestButton)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        endRestButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.height.equalTo(56)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

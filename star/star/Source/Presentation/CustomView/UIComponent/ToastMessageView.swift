//
//  ToastMessageView.swift
//  star
//
//  Created by 서문가은 on 2/14/25.
//

import UIKit
import SnapKit

class ToastMessageView: UIView {
    
    // 토스트 라벨
    let toastLabel = UILabel().then {
        $0.textColor = .starPrimaryText
        $0.font = UIFont.System.medium16
        $0.sizeToFit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .starDisabledTagBG.withAlphaComponent(0.7)
        layer.cornerRadius = 16
        isHidden = true
                
        addSubview(toastLabel)
        
        self.snp.makeConstraints {
            $0.width.equalTo(toastLabel.snp.width).multipliedBy(1.15)
            $0.height.equalTo(toastLabel.snp.height).multipliedBy(2)
        }
        
        toastLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension ToastMessageView {
    // 토스트 메세지 띄우기
    func showToastMessage(_ message: String) {
        UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 0.0
            self.toastLabel.text = message
        }) { _ in
            self.isHidden = true
            self.alpha = 1
        }
    }
}

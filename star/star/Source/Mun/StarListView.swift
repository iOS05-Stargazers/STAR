//
//  StarListView.swift
//  star
//
//  Created by 서문가은 on 1/22/25.
//

import UIKit

class StarListView: UIView {
    
    // MARK: - UI 컴포넌트
    
    
    // MARK: - 초기화

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 레이아웃 구성
    
    private func setupUI() {
        guard let backgroundImage = UIImage(named: "backgroundImage") else { return }
        backgroundColor = UIColor(patternImage: backgroundImage)
    }

}

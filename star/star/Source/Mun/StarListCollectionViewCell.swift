//
//  StarListCollectionViewCell.swift
//  star
//
//  Created by 서문가은 on 1/22/25.
//

import UIKit
import Then
import SnapKit

class StarListCollectionViewCell: UICollectionViewCell {
    
    static let id = "StarListCollectionViewCell"
    
    // MARK: - 초기화
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 레이아웃 설정
    
    private func setupUI() {
        layer.cornerRadius = 20
        backgroundColor = .colorStarBg
    }
}

//
//  StarListCollectionView.swift
//  star
//
//  Created by 서문가은 on 1/23/25.
//

import UIKit

class StarListCollectionView: UICollectionView {
    
    // MARK: - 초기화
    
    init() {
        super.init(frame: .zero, collectionViewLayout: StarListCollectionView.createCompositionalLayout())
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 레이아웃 구성

extension StarListCollectionView {
    // createCompositionalLayout 생성
    static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(section: StarListCollectionView.createSection())
    }
    
    // 섹션 생성
    static func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(96)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(96)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        
        return section
    }
    
    // 컬렉션뷰 설정
    private func setupCollectionView() {
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        self.register(
            StarListCollectionViewCell.self,
            forCellWithReuseIdentifier: StarListCollectionViewCell.id
        )
    }
}

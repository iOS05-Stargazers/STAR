//
//  StarListCollectionView.swift
//  star
//
//  Created by 서문가은 on 1/23/25.
//

import UIKit

final class StarListCollectionView: UICollectionView {
    
    // MARK: - 초기화
    
    init() {
        super.init(frame: .zero, collectionViewLayout: .init())
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

// MARK: - 스와이프 버튼 추가

extension StarListCollectionView {
    
    func addSwipeAction(
        trailingActionProvider: @escaping (IndexPath) -> [UIContextualAction] = { _ in [] }
    ) {
        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
            config.backgroundColor = .clear
            config.trailingSwipeActionsConfigurationProvider = { indexPath in
                let actions = trailingActionProvider(indexPath)
                let actionsConfig = UISwipeActionsConfiguration(actions: actions)
                actionsConfig.performsFirstActionWithFullSwipe = false // 풀스와이프 방지
                return actionsConfig
            }
            
            let listSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            listSection.interGroupSpacing = 12 // 셀간 간격
            return listSection
        }
        
        self.collectionViewLayout = layout
    }
}

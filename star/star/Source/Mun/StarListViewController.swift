//
//  StarListViewController.swift
//  star
//
//  Created by 서문가은 on 1/22/25.
//

import UIKit

class StarListViewController: UIViewController {
    
    // MARK: - UI 컴포넌트
    
    let starListView = StarListView()
    
    // MARK: - 생명주기 메서드
    
    override func loadView() {
        view = starListView
        setupCollectioView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 컬렉션뷰 설정
    private func setupCollectioView() {
        starListView.starListCollectionView.dataSource = self
        starListView.starListCollectionView.delegate = self
    }
}

// MARK: - collectionView 설정

extension StarListViewController: UICollectionViewDelegate {
}

extension StarListViewController: UICollectionViewDataSource {
    // 아이템 갯수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4 // 테스트 코드
    }
    
    // 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StarListCollectionViewCell.id,
            for: indexPath
        ) as? StarListCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}

extension StarListViewController: UICollectionViewDelegateFlowLayout {
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let cellHeight = (height - 10) / 5 // 임시 설정
        return CGSize(width: width, height: cellHeight)
    }
    
    // 아이템 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

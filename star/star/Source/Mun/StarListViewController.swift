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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectioView()
        setupDate()
    }

    // 컬렉션뷰 설정
    private func setupCollectioView() {
        starListView.starListCollectionView.dataSource = self
        starListView.starListCollectionView.delegate = self
    }
    
    private func setupDate() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyy년 M월 dd일 (E)"
        let todayLabel = dateFormatter.string(from: today)
        starListView.configureDate(date: todayLabel)
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

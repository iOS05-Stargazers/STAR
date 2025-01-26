//
//  StarListViewController.swift
//  star
//
//  Created by 서문가은 on 1/22/25.
//

import UIKit
import SnapKit

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
        setupAction()
        setupSwipeActions()
    }

    // 컬렉션뷰 설정
    private func setupCollectioView() {
        starListView.starListCollectionView.dataSource = self
        starListView.starListCollectionView.delegate = self
    }
    
    // 오늘 날짜 설정
    private func setupDate() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyy년 M월 dd일 (E)"
        let todayLabel = dateFormatter.string(from: today)
        starListView.configureDate(date: todayLabel)
    }
    
    // 액션 연결
    private func setupAction() {
        starListView.addStarButton.addAction(UIAction{ [weak self] _ in
            guard let self = self else { return }
            self.connectCreateModal()
        }, for: .touchUpInside)
    }
    
    // 스와이프 액션 설정
    private func setupSwipeActions() {
        starListView.starListCollectionView.addSwipeAction(
            trailingActionProvider: { [weak self] indexPath in
                var actions: [UIContextualAction] = []

                // 삭제 액션 추가
                let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
                    self?.showAlert()
                    completionHandler(false)
                }
                
                deleteAction.image = UIImage(systemName: "trash")
                actions.append(deleteAction)
            
                return actions
            }
        )
    }
    
    // 생성하기 모달 연결
    private func connectCreateModal() {
        let modalVC = StarModalViewController()
        modalVC.sheetPresentationController?.detents = [.custom(resolver: { context in
            let modalHeight = UIScreen.main.bounds.size.height - self.starListView.topView.frame.maxY - self.view.safeAreaInsets.bottom - 4
            return modalHeight
        })
        ]
        modalVC.sheetPresentationController?.selectedDetentIdentifier = .medium
        modalVC.sheetPresentationController?.prefersGrabberVisible = true
        modalVC.modalPresentationStyle = .formSheet
        modalVC.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalVC.view.layer.cornerRadius = 40
        present(modalVC, animated: true)
    }
    
    // 삭제하기 알럿 띄우기
    private func showAlert() {
        let starDeleteAlertViewController = StarDeleteAlertViewController()
        starDeleteAlertViewController.modalPresentationStyle = .overFullScreen
        starDeleteAlertViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        present(starDeleteAlertViewController, animated: true)
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

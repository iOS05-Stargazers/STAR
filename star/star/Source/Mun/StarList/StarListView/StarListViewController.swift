//
//  StarListViewController.swift
//  star
//
//  Created by 서문가은 on 1/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StarListViewController: UIViewController {
    
    // MARK: - UI 컴포넌트
    
    let starListView = StarListView()
    let viewModel = StarListViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - 생명주기 메서드
    
    override func loadView() {
        view = starListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupSwipeActions()
        
        navigationItem.hidesBackButton = true
    }
}

// MARK: - bind

extension StarListViewController {
    private func bind() {
        let viewWillAppears = rx.methodInvoked(#selector(viewWillAppear)).map { _ in }
        let input = StarListViewModel.Input(viewWillAppear: viewWillAppears)
        let output = viewModel.transform(input)

        // 컬렉션뷰 데이터 바인딩
        output.starDataSource
            .drive(starListView.starListCollectionView.rx.items(
                cellIdentifier: StarListCollectionViewCell.id,
                cellType: StarListCollectionViewCell.self)) { row, element, cell in
                    cell.configure(star: element)
                }
                .disposed(by: disposeBag)
        
        // 오늘 날짜 데이터 바인딩
        output.date
            .map { TodayDate.formatDate(date: $0)}
            .drive(starListView.todayDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 추가하기 버튼 이벤트 처리
        starListView.addStarButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.connectCreateModal()
            })
            .disposed(by: disposeBag)
        
        
        // 셀 선택 이벤트 처리
        starListView.starListCollectionView.rx.itemSelected
            .subscribe(onNext: { _ in
                print("셀 클릭")
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 실행 메서드

extension StarListViewController {
    // 스와이프 액션 설정
    private func setupSwipeActions() {
        starListView.starListCollectionView.addSwipeAction(
            trailingActionProvider: { [weak self] indexPath in
                var actions: [UIContextualAction] = []
                // 삭제 액션 추가
                let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completionHandler in
                    guard let self = self else { return }
                    self.showAlert()
                    completionHandler(false)
                }
                
                deleteAction.image = UIImage(systemName: "trash")
                actions.append(deleteAction)
                
                return actions
            }
        )
    }
    
    // 삭제하기 알럿 띄우기
    private func showAlert() {
        let starDeleteAlertViewController = StarDeleteAlertViewController()
        starDeleteAlertViewController.modalPresentationStyle = .overFullScreen
        starDeleteAlertViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        present(starDeleteAlertViewController, animated: true)
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
}

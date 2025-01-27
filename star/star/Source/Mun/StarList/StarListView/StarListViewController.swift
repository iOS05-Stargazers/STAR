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
    }
}

extension StarListViewController {
    // bind
    private func bind() {
        let viewWillAppears = rx.methodInvoked(#selector(viewWillAppear)).map { _ in }
        let input = StarListViewModel.Input(viewWillAppear: viewWillAppears)
        let output = viewModel.transform(input)
        
        output.starDataSource
            .drive(starListView.starListCollectionView.rx.items(
                cellIdentifier: StarListCollectionViewCell.id,
                cellType: StarListCollectionViewCell.self)) { row, element, cell in
                    cell.titleLabel.text = element.title
            }
            .disposed(by: disposeBag)
        
        output.date
            .map { TodayDate.formatDate(date: $0)}
            .drive(starListView.todayDateLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension StarListViewController {
    // 스와이프 액션 설정
    private func setupSwipeActions() {
        starListView.starListCollectionView.addSwipeAction(
            trailingActionProvider: { [weak self] indexPath in
                var actions: [UIContextualAction] = []
                // 삭제 액션 추가
                let deleteAction = UIContextualAction(style: .destructive, title: nil) {[weak self] _, _, completionHandler in
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
}

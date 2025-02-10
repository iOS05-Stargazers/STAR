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

final class StarListViewController: UIViewController {
    
    // MARK: - UI 컴포넌트
    
    let starListView = StarListView()
    let viewModel = StarListViewModel()
    
    let deleteActionSubject = PublishSubject<Int>()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        // 온보딩 뷰를 보여주지 않았다면 온보딩뷰 표시
        if !UserDefaults.standard.isCoachMarkShown {
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.modalPresentationStyle = .overFullScreen
            present(onboardingViewController, animated: false)
        }
    }
}

// MARK: - bind

extension StarListViewController {
    
    private func bind() {
        let viewWillAppears = rx.methodInvoked(#selector(viewWillAppear)).map { _ in }
        let input = StarListViewModel.Input(
            viewWillAppear: viewWillAppears,
            deleteAction: deleteActionSubject)
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
        
        // 스타 바인딩
        output.star
            .drive(with: self, onNext: { owner, star in
                owner.showAlert(star)
            })
            .disposed(by: disposeBag)
        
        // 휴식 버튼 이벤트 처리
        starListView.restButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.connectRestModal()
            })
            .disposed(by: disposeBag)
        
        // 추가하기 버튼 이벤트 처리
        starListView.addStarButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.connectCreateModal(mode: .create)
            })
            .disposed(by: disposeBag)
        
        // 셀 선택 이벤트 처리
        starListView.starListCollectionView.rx.modelSelected(Star.self)
            .withUnretained(self)
            .subscribe(onNext: { owner, star in
                self.connectCreateModal(mode: .edit(star: star))
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
                    deleteActionSubject.onNext(indexPath.item)
                }
                
                deleteAction.image = UIImage(systemName: "trash")
                actions.append(deleteAction)
                
                return actions
            }
        )
    }
    
    // 삭제하기 알럿 띄우기
    private func showAlert(_ star: Star) {
        let starDeleteAlertViewModel = StarDeleteAlertViewModel(star: star, refreshRelay: viewModel.refreshRelay)
        let starDeleteAlertViewController = StarDeleteAlertViewController(viewModel: starDeleteAlertViewModel)
        starDeleteAlertViewController.modalPresentationStyle = .overFullScreen
        starDeleteAlertViewController.view.backgroundColor = .starModalOverlayBG
        present(starDeleteAlertViewController, animated: false)
    }
    
    // 휴식 화면 모달 연결
    private func connectRestModal() {
        let restStartViewController = RestStartViewController()
        restStartViewController.view.backgroundColor = .starModalOverlayBG
        restStartViewController.modalPresentationStyle = .overFullScreen
        present(restStartViewController, animated: true)
    }
    
    // 생성하기 모달 연결
    private func connectCreateModal(mode: StarModalMode) {
        let modalViewModel = StarModalViewModel(mode: mode, refreshRelay: viewModel.refreshRelay)
        let modalVC = StarModalViewController(viewModel: modalViewModel)
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

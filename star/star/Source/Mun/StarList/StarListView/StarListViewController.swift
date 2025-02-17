//
//  StarListViewController.swift
//  star
//
//  Created by 서문가은 on 1/22/25.
//


// viewDidLoad -> 휴식중인지 확인(userDefaults)
// 맞으면 모달 연결
// 휴식 설정 화면에서 휴식하기 누르면 starListVM에서 이벤트 방출 받고, 휴식중 화면 띄우기

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
        bind()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - bind

extension StarListViewController {
    
    private func bind() {
        let viewWillAppears = rx.methodInvoked(#selector(viewDidLoad)).map { _ in }
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
        
        // 스타 모달 상태 바인딩
        output.starModalState
            .drive(with: self, onNext: { owner, thisModal in
                owner.connectModal(thisModal)
            })
            .disposed(by: disposeBag)
        
        // 휴식 버튼 이벤트 처리
        starListView.restButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.connectRestStartModal()
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
    
    // 모달 연결
    private func connectModal(_ modal: StarModalState) {
        switch modal {
        case .onboarding:
            connnectOnboarding()
        case .restSetting:
            connectRestSettingModal()
        case .restStart:
            connectRestStartModal()
        case .resting:
            connectRestingModal()
        }
    }
    
    // 삭제하기 알럿 띄우기
    private func showAlert(_ star: Star) {
        let starDeleteAlertViewModel = StarDeleteAlertViewModel(star: star, refreshRelay: viewModel.refreshRelay)
        let starDeleteAlertViewController = StarDeleteAlertViewController(viewModel: starDeleteAlertViewModel)
        starDeleteAlertViewController.modalPresentationStyle = .overFullScreen
        starDeleteAlertViewController.view.backgroundColor = .starModalOverlayBG
        present(starDeleteAlertViewController, animated: false)
    }
    
    // 온보딩 모달 연결
    private func connnectOnboarding() {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.modalPresentationStyle = .overFullScreen
        present(onboardingViewController, animated: false)
    }
    
    // 휴식 진입 화면 모달 연결
    private func connectRestStartModal() {
        let restStartViewModel = RestStartViewModel(restStartCompleteRelay: viewModel.restStartCompleteRelay)
        let restStartViewController = RestStartViewController(restStartViewModel: restStartViewModel)
        restStartViewController.view.backgroundColor = .starModalOverlayBG
        restStartViewController.modalPresentationStyle = .overFullScreen
        present(restStartViewController, animated: true)
    }
    
    // 휴식 설정 화면 모달 연결
    private func connectRestSettingModal() {
        let restSettingModalViewController = RestSettingModalViewController(restingCompleteRelay: viewModel.restSettingCompleteRelay)
        restSettingModalViewController.modalPresentationStyle = .pageSheet
        restSettingModalViewController.sheetPresentationController?.prefersGrabberVisible = true
        
        // 모달 화면 높이 설정
        if let sheet = restSettingModalViewController.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom { _ in
                        return 350
                    }
                ]
            } else {
                sheet.detents = [.medium()]
            }
        }
        
        restSettingModalViewController.view.layer.cornerRadius = 40
        present(restSettingModalViewController, animated: true)
    }
    
    // 휴식중 화면 모달 연결
    private func connectRestingModal() {
        let restingViewController = RestingViewController()
        restingViewController.view.backgroundColor = .starModalOverlayBG
        restingViewController.modalPresentationStyle = .overFullScreen
        present(restingViewController, animated: true)
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

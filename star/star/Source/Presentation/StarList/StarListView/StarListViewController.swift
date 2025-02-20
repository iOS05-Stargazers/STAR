//
//  StarListViewController.swift
//  star
//
//  Created by 서문가은 on 1/22/25.
//

import UIKit
import SnapKit
import RxSwift

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
        let viewWillAppears = rx.methodInvoked(#selector(viewWillAppear)).map { _ in }
        let addButtonTapped = starListView.addStarButton.rx.tap.asObservable()
        let restButtonTapped = starListView.restButton.rx.tap.asObservable()
        let input = StarListViewModel.Input(
            viewWillAppear: viewWillAppears,
            addButtonTapped: addButtonTapped,
            restButtonTapped: restButtonTapped,
            deleteAction: deleteActionSubject)
        let output = viewModel.transform(input)
        
        // 컬렉션뷰 데이터 바인딩
        output.starDataSource
            .do(onNext: { [weak self] star in
                guard let self = self else { return }
                let starIsEmpty = star.isEmpty ? false : true
                // 스타가 없으면 스타없음라벨 활성화
                self.starListView.noStarLabel.isHidden = starIsEmpty
            })
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
                owner.connectRestStartModal(mode: .delete(star: star))
            })
            .disposed(by: disposeBag)
        
        // 스타 모달 상태 바인딩
        output.starModalState
            .drive(with: self, onNext: { owner, thisModal in
                owner.connectModal(thisModal)
            })
            .disposed(by: disposeBag)
        
        // 생성 가능 여부 바인딩
        output.availability
            .drive(with:self, onNext: { owner, result in
                owner.handleCreationAvailability(result)
            })
            .disposed(by: disposeBag)
        
        // 셀 선택 이벤트 처리
        starListView.starListCollectionView.rx.modelSelected(Star.self)
            .withUnretained(self)
            .subscribe(onNext: { owner, star in
                HapticManager.shared.play(style: .selection)
                owner.connectRestStartModal(mode: .edit(star: star))
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
            connectOnboarding()
        case .edit(let star):
            connectCreateModal(mode: .edit(star: star))
        case .delete(let star):
            showAlert(star)
        case .restSetting:
            connectRestSettingModal()
        case .restStart:
            connectRestStartModal(mode: .rest)
        case .resting:
            connectRestingModal()
        }
    }
    
    // 삭제하기 알럿 띄우기
    private func showAlert(_ star: Star) {
        // 삭제 알럿 띄울 시 진동
        let starDeleteAlertViewModel = StarDeleteAlertViewModel(star: star, refreshRelay: viewModel.refreshRelay)
        let starDeleteAlertViewController = StarDeleteAlertViewController(viewModel: starDeleteAlertViewModel)
        starDeleteAlertViewController.modalPresentationStyle = .overFullScreen
        starDeleteAlertViewController.view.backgroundColor = .starModalOverlayBG
        present(starDeleteAlertViewController, animated: false)
    }
    
    // 온보딩 모달 연결
    private func connectOnboarding() {
        let onboardingViewModel = OnboardingViewModel()
        let onboardingViewController = OnboardingViewController(viewModel: onboardingViewModel)
        onboardingViewController.modalPresentationStyle = .overFullScreen
        present(onboardingViewController, animated: false)
    }
    
    // 휴식 진입 화면 모달 연결
    private func connectRestStartModal(mode: DelayMode) {
        let restStartViewModel = RestStartViewModel(restStartCompleteRelay: viewModel.restStartCompleteRelay, mode: mode)
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
        let modalViewModel = StarEditViewModel(mode: mode, refreshRelay: viewModel.refreshRelay)
        let modalVC = StarEditViewController(viewModel: modalViewModel)
        modalVC.modalPresentationStyle = .custom
        modalVC.transitioningDelegate = self
        modalVC.view.layer.cornerRadius = 40
        present(modalVC, animated: true)
    }
    
    // 생성 가능 여부 처리
    private func handleCreationAvailability(_ result: Availability) {
        switch result {
        case .available(let state):
            if state == .create {
                connectCreateModal(mode: .create)
            } else {
                connectRestStartModal(mode: .rest)
            }
        case .unavailable:
            guard let text = result.message else { return }
            self.starListView.toastMessageView.showToastMessage(text)
        }
    }
}

// MARK: - CustomModalTransition에서 설정한 커스텀 모달 애니메이션 적용

extension StarListViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented,
                                            presenting: presenting)
    }
}

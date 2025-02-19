//
//  OnboardingViewController.swift
//  star
//
//  Created by Eden on 2/13/25.
//

import UIKit
import SnapKit
import RxSwift

final class OnboardingViewController: UIViewController {
    
    private let collectionView = OnboardingCollectionView()
    private let viewModel: OnboardingViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    // MARK: - Set Up UI
    
    private func setupUI() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Bind ViewModel
    
    private func bind() {
        let input = OnboardingViewModel.Input(
            skipTapped: collectionView.skipButton.rx.tap.asObservable(),
            pageChanged: observePageChanged()
        )
        
        let output = viewModel.transform(input: input)
        
        /// 페이지 개수를 UIPageControl에 바인딩
        viewModel.pages
            .map { $0.count }
            .bind(to: collectionView.pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        /// 컬렉션 뷰에 데이터 바인딩
        viewModel.pages
            .bind(to: collectionView.collectionView.rx.items(
                cellIdentifier: OnboardingCell.identifier,
                cellType: OnboardingCell.self
            )) { _, page, cell in
                cell.configure(with: page)
            }
            .disposed(by: disposeBag)
        
        /// 스크롤을 멈추면 현재 페이지를 감지하여 업데이트
        let pageChangedObservable = collectionView.collectionView.rx.didEndDecelerating
            .map { [weak self] in
                guard let self = self else { return 0 }
                return Int(round(self.collectionView.collectionView.contentOffset.x / self.collectionView.collectionView.frame.width))
            }
            .distinctUntilChanged()
        
        /// 현재 페이지가 변경되면 컬렉션 뷰를 해당 페이지로 스크롤
        output.currentPage
            .withLatestFrom(viewModel.pages.asDriver(onErrorDriveWith: .empty())) { ($0, $1) }
            .drive(with: self, onNext: { owner, values in
                let (page, pages) = values
                
                guard pages.count > 0, page < pages.count else { return }
                
                owner.collectionView.scrollToItem(at: page)
                owner.collectionView.updatePageControl(page)
                owner.collectionView.updateSkipButtonText(isLastPage: page == pages.count - 1)
            })
            .disposed(by: disposeBag)
        
        /// 스크롤하면 현재 페이지를 감지하여 ViewModel에 전달
        pageChangedObservable
            .bind(to: viewModel.currentPage)
            .disposed(by: disposeBag)
        
        /// 스킵 버튼이 눌렸을 때 온보딩 종료
        output.skipTrigger
            .drive(with: self, onNext: { owner, _ in
                owner.navigateToStarList()
            })
            .disposed(by: disposeBag)
    }
    
    /// 스크롤 이벤트 감지
    private func observePageChanged() -> Observable<Int> {
        return collectionView.collectionView.rx.didEndDecelerating
            .map { [weak self] in
                guard let self = self else { return 0 }
                return Int(round(self.collectionView.collectionView.contentOffset.x / self.collectionView.collectionView.frame.width))
            }
            .distinctUntilChanged()
    }
    
    private func navigateToStarList() {
        UserDefaults.standard.isCoachMarkShown = true
        dismiss(animated: false, completion: nil)
    }
}

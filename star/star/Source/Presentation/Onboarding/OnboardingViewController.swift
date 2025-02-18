//
//  OnboardingViewController.swift
//  star
//
//  Created by Eden on 2/13/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

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
            pageChanged: collectionView.collectionView.rx.didEndDecelerating
                .map { [weak self] in
                    guard let self = self else { return 0 }
                    return Int(round(self.collectionView.collectionView.contentOffset.x / self.collectionView.collectionView.frame.width))
                }
                .distinctUntilChanged()
        )
        
        let output = viewModel.transform(input: input)
        
        viewModel.pages
            .withUnretained(self)
            .subscribe(onNext: { owner, pages in
                owner.collectionView.updatePageCount(pages.count)
                owner.collectionView.updatePages(pages)
            })
            .disposed(by: disposeBag)
        
        output.currentPage
            .drive(with: self,onNext: { owner, page in
                guard owner.collectionView.pages.count > 0 else { return }
                owner.collectionView.updateCurrentPage(page: page)
            })
            .disposed(by: disposeBag)
        
        output.skipTrigger
            .drive(with: self,onNext: { owner, _ in
                owner.navigateToStarList()
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToStarList() {
        UserDefaults.standard.isCoachMarkShown = true
        dismiss(animated: false, completion: nil)
    }
}

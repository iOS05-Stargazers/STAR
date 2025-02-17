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
    
    // MARK: - init
    
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
        collectionView.bind(viewModel: viewModel)
        
        viewModel.transform(
            input: OnboardingViewModel.Input(
                skipTapped: collectionView.skipButton.rx.tap.asObservable(),
                pageChanged: collectionView.pageChanged.asObservable()
            )
        ).skipTrigger
            .drive(with: self, onNext: { owner, _ in
                owner.navigateToStarList()
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToStarList() {
        dismiss(animated: false, completion: nil)
    }
}

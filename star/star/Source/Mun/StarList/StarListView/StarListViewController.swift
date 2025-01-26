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
    }

}

extension StarListViewController {
    private func bind() {
        let viewWillAppear = rx.methodInvoked(#selector(viewWillAppear)).map { _ in }
        let input = StarListViewModel.Input(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input)
        
        output.date
            .map { TodayDate.formatDate(date: $0)}
            .drive(starListView.todayDateLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

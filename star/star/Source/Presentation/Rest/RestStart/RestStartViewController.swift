//
//  RestStartViewController.swift
//  star
//
//  Created by 서문가은 on 2/10/25.
//

import UIKit
import RxSwift

final class RestStartViewController: UIViewController {
    
    private let restStartView = RestStartView()
    private let restStartViewModel: RestStartViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - 생명주기 메서드
    
    init(restStartViewModel: RestStartViewModel) {
        self.restStartViewModel = restStartViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = restStartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - bind
    
    private func bind() {
        let output = restStartViewModel.transform()
        
        // 카운트 바인딩
        output.count
            .filter({ count in
                count != 0
            })
            .map { "\($0)" }
            .drive(restStartView.countLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 완료 바인딩
        output.complete
            .drive(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
                owner.restStartViewModel.restStartCompleteRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        // 취소버튼 이벤트 처리
        restStartView.cancelButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

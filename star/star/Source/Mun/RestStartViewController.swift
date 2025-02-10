//
//  RestStartViewController.swift
//  star
//
//  Created by 서문가은 on 2/10/25.
//

import UIKit
import RxSwift
import RxCocoa

class RestStartViewController: UIViewController {
    
    private let restStartView = RestStartView()
    private let restStartViewModel = RestStartViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - 생명주기 메서드
    
    override func loadView() {
        view = restStartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - bind
    
    private func bind() {
        // 취소버튼 이벤트 처리
        restStartView.cancelButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.closeModal()
            })
            .disposed(by: disposeBag)
        
        let output = restStartViewModel.transform()
        
        // 카운트 바인딩
        output.count
            .do(onNext: { [weak self] count in
                if count == 0 {
                    guard let self = self else { return }
                    self.connectRestSettingModal()
                }
            })
            .filter({ count in
                count != 0
            })
            .map { "\($0)"}
            .drive(restStartView.countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension RestStartViewController {
    
    // 모달 종료
    private func closeModal() {
        dismiss(animated: true)
    }
    
    // 휴식 설정 모달 연결
    private func connectRestSettingModal() {
        dismiss(animated: true) // 임의 연결, 휴식 설정 모달과 연결 예정
    }
}

//
//  StarDeleteAlertViewModel.swift
//  star
//
//  Created by 서문가은 on 2/1/25.
//
import RxSwift
import RxCocoa

final class StarDeleteAlertViewModel {
    
    private let star: Star
    private let CloseAction: PublishRelay<Void>
    private let disposeBag = DisposeBag()
    
    init(star: Star, CloseAction: PublishRelay<Void>) {
        self.star = star
        self.CloseAction = CloseAction
    }
    
    private func deleteStar() {
        StarManager.shared.delete(star)
    }
    
    private func doClose() {
        CloseAction.accept(())
    }
}

extension StarDeleteAlertViewModel {
    
    struct Input {
        let cancelButtonTapped: Observable<Void>
        let deleteButtonTapped: Observable<Void>
    }
    
    func transform(_ input: Input) {
        input.cancelButtonTapped
            .subscribe(onNext: {
                self.doClose()
            })
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .subscribe(onNext: {
                self.deleteStar()
                self.doClose()
            })
            .disposed(by: disposeBag)
    }
}

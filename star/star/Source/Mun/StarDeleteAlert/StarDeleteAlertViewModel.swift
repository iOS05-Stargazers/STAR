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
    private let refreshRelay: PublishRelay<Void>
    private let disposeBag = DisposeBag()
    
    init(star: Star, refreshRelay: PublishRelay<Void>) {
        self.star = star
        self.refreshRelay = refreshRelay
    }
    
    // 스타 삭제
    private func performStarDeletion() {
        StarManager.shared.delete(star)
        FamilyControlsManager.refreshList()
    }
    
    // 종료 방출
    private func closeAlert() {
        refreshRelay.accept(())
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
                self.closeAlert()
            })
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .subscribe(onNext: {
                self.performStarDeletion()
                self.closeAlert()
            })
            .disposed(by: disposeBag)
    }
}

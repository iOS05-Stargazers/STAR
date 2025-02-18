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
        NotificationManager().cancelNotification(star: star)
        BlockManager().deleteSchedule(star)
        
        FamilyControlsManager().updateBlockList()
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
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.closeAlert()
            })
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.performStarDeletion()
                owner.closeAlert()
                // 삭제 버튼 탭 시 진동
                HapticManager.shared.play(1, style: .notification(.success))
            })
            .disposed(by: disposeBag)
    }
}

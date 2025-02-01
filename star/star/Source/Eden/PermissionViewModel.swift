//
//  PermissionViewModel.swift
//  star
//
//  Created by Eden on 1/31/25.
//

import Foundation
import RxSwift
import RxCocoa

final class PermissionViewModel {
    
    private let familyControlsManager: FamilyControlsManager
    
    init(familyControlsManager: FamilyControlsManager = FamilyControlsManager()) {
        self.familyControlsManager = familyControlsManager
    }
}

extension PermissionViewModel {
    
    struct Input {
        let requestPermissionTrigger: Observable<Void>
    }
    
    struct Output {
        let navigateToStarList: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let navigateToStarList = PublishRelay<Void>()
        
        input.requestPermissionTrigger
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                return self.requestScreenTimePermission()
            }
            .filter { $0 }
            .map { _ in }
            .bind(to: navigateToStarList)
            .disposed(by: DisposeBag())
        
        return Output(
            navigateToStarList: navigateToStarList.asObservable()
        )
    }
    
    private func requestScreenTimePermission() -> Observable<Bool> {
        return Observable.create { observer in
            self.familyControlsManager.requestAuthorization {
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

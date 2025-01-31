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
    private let disposeBag = DisposeBag()
    
    init() {}
    
}

extension PermissionViewModel {
    
    // MARK: - Input
    
    struct Input {
        let requestPermissionTrigger: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let isPermissionGranted: Observable<Bool>
        let navigateToStarList: Observable<Void>
    }
}

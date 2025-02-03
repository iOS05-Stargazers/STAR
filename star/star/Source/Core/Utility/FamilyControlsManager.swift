//
//  FamilyControlsManager.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-27.
//

import Foundation
import FamilyControls
import RxSwift
import RxCocoa

final class FamilyControlsManager: ObservableObject {
    static let shared = FamilyControlsManager()
    private init() {
        // BehaviorSubject의 값을 @Published 변수에 반영
        hasScreenTimePermission
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] newValue in
                self?.hasScreenTimePermissionPublished = newValue
            })
            .disposed(by: disposeBag)
    }

    private let disposeBag = DisposeBag()
    
    let authorizationCenter = AuthorizationCenter.shared
    
    let hasScreenTimePermission = BehaviorSubject<Bool>(value: false)
    @Published var hasScreenTimePermissionPublished: Bool = false
    
    // MARK: - ScreenTime API 사용 권한 요청
    /// 권한 요청을 비동기로 수행하고 결과를 RxSwift 스트림으로 반환
    func requestAuthorization() -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            if self.authorizationCenter.authorizationStatus == .approved {
                print("ScreenTime Permission approved")
                self.hasScreenTimePermission.onNext(true)
                single(.success(true))
            } else {
                Task {
                    do {
                        try await self.authorizationCenter.requestAuthorization(for: .individual)
                        self.hasScreenTimePermission.onNext(true)
                        single(.success(true))
                    } catch {
                        print("Failed to enroll with error: \(error)")
                        self.hasScreenTimePermission.onNext(false)
                        single(.success(false))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: - 스크린타임 권한 조회
    /// 메서드 호출 시 현재 ScreenTime API의 권한 상태를 조회할 수 있습니다.
    func requestAuthorizationStatus() -> AuthorizationStatus {
        authorizationCenter.authorizationStatus
    }
    
    // MARK: ScreenTime 권한 취소
    /// 권한 상태가 .approve인 상태에서 메서드 호출 시
    ///  ScreenTIme  권한 상태를 .notDetermined로 변경합니다.
    func requestAuthorizationRevoke() {
        authorizationCenter.revokeAuthorization(completionHandler: { result in
            switch result {
            case .success:
                print("Success")
            case .failure(let failure):
                print("\(failure) - failed revoke Permission")
            }
        })
    }
    
    // MARK: - 권한 상태 업데이트
    /// hasScreenTimePermission의 상태를 변경하기 위한 메서드
    func updateAuthorizationStatus(authStatus: AuthorizationStatus) {
        let newStatus: Bool
        switch authStatus {
        case .notDetermined, .denied:
            newStatus = false
        case .approved:
            newStatus = true
        @unknown default:
            fatalError("요청한 권한설정 타입에 대한 처리는 없습니다")
        }
        hasScreenTimePermission.onNext(newStatus)
    }
}

//
//  DeviceActivityManager.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-30.
//

import Foundation
import DeviceActivity
import ManagedSettings
import RxSwift
import RxCocoa

// MARK: - 모니터링 관련 동작을 제어하는 클래스
final class DeviceActivityManager {
    static let shared = DeviceActivityManager()
    private init() {}
    
    /// DeviceActivityCenter는 설정한 스케줄에 대한 모니터링을 제어해주는 클래스
    /// 모니터링 시작 및 중단 등의 동작 처리를 위해 인스턴스를 생성해줌
    private let deviceActivityCenter = DeviceActivityCenter()
    
    private let disposeBag = DisposeBag()
    
    /// 현재 모니터링 상태
    private let isMonitoringSubject = BehaviorSubject<Bool>(value: false)
    
    /// 외부에서 구독할 수 있는 Observable (현재 모니터링 상태)
    var isMonitoring: Observable<Bool> {
        return isMonitoringSubject.asObservable()
    }
    
    // MARK: - Device Activity 활동 모니터링 시작
    /// warningTime을 활용하여, 특정 이벤트 시점 전에 알림을 줄 수도 있다:
    /// https://github.com/DeveloperAcademy-POSTECH/MC2-Team18-sunghoyazaza
    func startMonitoring(
        startTime: DateComponents,
        endTime: DateComponents,
        deviceActivityName: DeviceActivityName = .daily,
        warningTime: DateComponents = DateComponents(minute: 5)
    ) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            let schedule = DeviceActivitySchedule(
                intervalStart: startTime,
                intervalEnd: endTime,
                repeats: true,
                warningTime: warningTime
            )
            
            do {
                try self.deviceActivityCenter.startMonitoring(deviceActivityName, during: schedule)
                self.isMonitoringSubject.onNext(true)
                print("모니터링 시작됨: \(deviceActivityName.rawValue)")
                single(.success(true))
            } catch {
                print("모니터링 시작 실패: \(error)")
                single(.success(false))
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - Device Activity 활동 모니터링 중단
    func stopMonitoring() -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            self.deviceActivityCenter.stopMonitoring()
            self.isMonitoringSubject.onNext(false)
            print("모니터링 중단됨")
            single(.success(true))
            
            return Disposables.create()
        }
    }
}

// MARK: - Schedule Name List
extension DeviceActivityName {
    static let daily = Self("daily")
}

// MARK: - MAnagedSettingsStore List
extension ManagedSettingsStore.Name {
    static let daily = Self("daily")
}

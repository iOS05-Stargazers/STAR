//
//  DeviceActivityMonitorExtension.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-30.
//

import Foundation
import DeviceActivity
import ManagedSettings
import RxSwift

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
final class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let coreDataManager = StarManager.shared
    let disposeBag = DisposeBag()
    
    // 세션 매핑: UUID (CoreData의 StarEntity) -> DeviceActivityName
    var sessionStores: [UUID: ManagedSettingsStore] = [:]
    
    override init() {
        super.init()
        loadSessions()
    }
    
    // MARK: - 현재 CoreData에서 모든 스케줄을 불러와 activeSessions에 저장
    private func loadSessions() {
        // FIXME: - 데이터 로드 필요
        let starList: [Star] = /*coreDataManager.fetchAllStars()*/[]
        sessionStores = [:]
        
        for star in starList {
            /*guard*/ let id = star.identifier /*else { continue }*/
            sessionStores[id] = ManagedSettingsStore(named: ManagedSettingsStore.Name("\(id.uuidString)"))
        }
    }
    
    // MARK: - 세션 시작: 특정 스케줄의 제한을 적용
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        print("[\(activity.rawValue)] 세션 시작됨")
        
//        // CoreData에서 해당 스케줄 찾기
//        guard let starID = UUID(uuidString: activity.rawValue),
////              let schedule: Schedule = coreDataManager.fetchStar(starID),
//              /*let store = sessionStores[starID]*/ else {
//            print("해당 스케줄을 찾을 수 없음: \(activity.rawValue)")
//            return
//        }

        /// starID에 appTokens 구현 필요
        /// ApplicationToken 관련 사항 알아보기
        /*
        // 선택한 앱 토큰 로드
        let appTokens = schedule.appTokens ?? []
        
        if appTokens.isEmpty {
            store.shield.applications = nil
        } else {
            store.shield.applications = appTokens
        }
        
        print("차단된 앱 목록: \(appTokens)")
         */
    }
    
    // MARK: - 스케줄의 종료 시점 이후 처음으로 기기가 사용될 때 or 모니터링 중단 시에 호출되는 메서드
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
        // 해당 store에 대해 적용되던 모든 실드 해제
        
        guard let starID = UUID(uuidString: activity.rawValue),
              let store = sessionStores[starID] else { return }
        
        store.clearAllSettings()
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
        
        guard let starID = UUID(uuidString: activity.rawValue),
              let store = sessionStores[starID] else { return }
        
        store.shield.applications = nil
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(
        _ event: DeviceActivityEvent.Name,
        activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}

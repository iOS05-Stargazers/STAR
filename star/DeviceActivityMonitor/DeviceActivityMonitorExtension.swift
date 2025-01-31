//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitorExtension
//
//  Created by t0000-m0112 on 2025-01-31.
//

import Foundation
import DeviceActivity
import ManagedSettings
import RxSwift

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
final class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let store = ManagedSettingsStore()
//    let coreDataManager = SharedCoreDataManager.shared
    let disposeBag = DisposeBag()
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        print("DeviceActivityMonitor 시작됨: \(activity.rawValue)")
        
        // Star 상태 변경 감지 로직 구현 필요 -> updateAppBlocking
        
        // Core Data 변경 감지 시작
//        coreDataManager.observeChanges()
        
        // 초기 데이터 가져오기
//        coreDataManager.fetchStars()
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        print("DeviceACtivityMonitor 종료됨: \(activity.rawValue)")
        
        // 모든 앱 차단 해제
        removeAllAppRestriction()
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
    
    private func updateAppBlocking(stars: [StarEntity]) {
        var appsToBlock = Set<Application>()
        
        for star in stars {
            guard let startTime = star.startTime, let endTime = star.endTime else { continue }
            
            if isCurrentTimeInRange(startTime: startTime, endTime: endTime) {
                let appList = star.appList?.components(separatedBy: ",") ?? []
                let validApps = appList.compactMap { Application(bundleIdentifier: $0) }
                appsToBlock.formUnion(validApps)
            }
        }
        
        store.application.blockedApplications = appsToBlock.isEmpty ? nil : appsToBlock
        print("차단된 앱 목록 업데이트: \(appsToBlock)")
    }
    
    private func isCurrentTimeInRange(startTime: String, endTime: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let start = dateFormatter.date(from: startTime),
              let end = dateFormatter.date(from: endTime) else {
            print("시간 변환 실패")
            return false
        }
        
        let now = Date()
        return now >= start && now <= end
    }
    
    private func applyAppRestrictions(apps: [String]) {
        let validApps = apps
            .filter { $0.contains(".") } // 번들 ID인지 확인
            .compactMap { Application(bundleIdentifier: $0) } // Application 타입으로 변환
        
        store.application.blockedApplications = Set(validApps)
        print("차단된 앱 목록: \(validApps)")
    }
    
    private func removeAllAppRestriction() {
        store.application.blockedApplications = nil
        print("모든 앱 차단 해제됨")
    }
}

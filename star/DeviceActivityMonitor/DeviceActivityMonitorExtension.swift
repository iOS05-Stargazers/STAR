//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitor+Extension
//
//  Created by 0-jerry on 2/13/25.
//

import DeviceActivity
import Foundation

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        // 휴식 중일 경우, 블록리스트를 업데이트 하지 않음
        guard RestManager().restEndTimeGet() == nil else { return }
        // DeviceActivityName과 매칭되는 Star의 블록리스트를 적용
        guard let star = Star(from: activity) else { return }
        ManagedSettingsStoreManager().startStar(star)
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        // 스타 중단에 대한 스케줄인 경우
        if let rawValue = StarBreakIDFormmater.rawValue(activity.rawValue),
           let uuid = UUID(uuidString: rawValue),
           let star = StarManager.shared.read(uuid) {
            StarBreakManager().breakEnd(of: star)
            return
        }
        // 휴식중인지 검증
        guard activity != .rest else {
            ManagedSettingsStoreManager().update()
            return
        }
        // 스타 스케줄인지 검증
        guard let star = Star(from: activity) else { return }
        ManagedSettingsStoreManager().endStar(star)
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
}

private extension Star {
    init?(from deviceActivityName: DeviceActivityName) {
        guard let uuid = UUID(uuidString: deviceActivityName.rawValue),
              let star = StarManager.shared.read(uuid) else { return nil }
        
        self = star
    }
}

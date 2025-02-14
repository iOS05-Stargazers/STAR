//
//  YouTubeBlocker.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/26.
//

import Foundation
import ManagedSettings
import FamilyControls
import DeviceActivity

struct BlockManager {
    private let deviceActivityCenter = DeviceActivityCenter()
    // 앱 차단 로직
    func block(star: Star) {
        
        let startTime = star.schedule.startTime
        let endTime = star.schedule.endTime
        
        // 모니터 DeviceActivitySchedule 설정
        let blockSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: startTime.hour,
                                          minute: startTime.minute),
            intervalEnd: DateComponents(hour: endTime.hour,
                                        minute: endTime.minute),
            repeats: true
        )
 
        do {
            try deviceActivityCenter.startMonitoring(DeviceActivityName(star.identifier.uuidString),
                                                     during: blockSchedule)
        } catch {
            return
        }
        FamilyControlsManager.updateList()
    }
    
    func activities() {
        print(DeviceActivityCenter().activities.map { $0.rawValue })
    }
    
}

// MARK: - 휴식기능

extension BlockManager {
    
    func rest() {
        guard let restTime = UserDefaults.appGroups.restEndTimeGet() else { return }
        let now = Calendar.current.dateComponents([.day, .hour, .minute], from: .now.addingTimeInterval(-900))
        let end = Calendar.current.dateComponents([.day, .hour, .minute], from: restTime)
        
        // 모니터 DeviceActivitySchedule 설정
        let blockSchedule = DeviceActivitySchedule(
            intervalStart: now,
            intervalEnd: end,
            repeats: false
        )
        
        do {
            try deviceActivityCenter.startMonitoring(.rest,
                                                     during: blockSchedule)
        } catch {
            return
        }
        FamilyControlsManager.updateList()
    }

}

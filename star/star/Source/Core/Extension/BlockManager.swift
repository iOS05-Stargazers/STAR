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
    
    // 스타 스케쥴 추가
    func creatSchedule(star: Star) {
        let startTime = star.schedule.startTime
        let endTime = star.schedule.endTime
        
        // 모니터 DeviceActivitySchedule 설정
        let blockSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: startTime.hour, minute: startTime.minute),
            intervalEnd: DateComponents(hour: endTime.hour, minute: endTime.minute),
            repeats: true
        )
        
        setSchedule(name: .init(from: star), blockSchedule)
    }
    
    // 휴식 스케쥴 추가
    func rest() {
        guard let restEndTime = UserDefaults.appGroups.restEndTimeGet() else { return }
        let startTime = StarTime(date: .now.addingTimeInterval(-900))
        let endTime = StarTime(date: restEndTime)
        
        let blockSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: startTime.hour, minute: startTime.minute),
            intervalEnd: DateComponents(hour: endTime.hour, minute: endTime.minute),
            repeats: false
        )
        
        setSchedule(name: .rest, blockSchedule)
    }
    
    func endRest() {
        deviceActivityCenter.stopMonitoring([.rest])
    }
    
    private func setSchedule(name activityName: DeviceActivityName,
                             _ schedule: DeviceActivitySchedule) {
        do {
            try deviceActivityCenter.startMonitoring(activityName,
                                                     during: schedule)
        } catch {
            print(error.localizedDescription)
        }
        FamilyControlsManager().updateBlockList()
    }
    
    func refreshSchedule() {
        resetSchedule()

        StarManager.shared.read()
            .forEach { creatSchedule(star: $0) }
    }
    
    func deleteSchedule(_ star: Star) {
        deviceActivityCenter.stopMonitoring([.init(star.identifier.uuidString)])
    }
    
    func updateSchedule(_ star: Star) {
        deviceActivityCenter.stopMonitoring([.init(star.identifier.uuidString)])
        creatSchedule(star: star)
    }
    
    private func resetSchedule() {
        let deviceActivityCenter = DeviceActivityCenter()
        deviceActivityCenter.stopMonitoring([])
    }
}

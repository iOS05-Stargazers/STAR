//
//  BlockManager.swift
//  ScreenTimeAPIExample
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

    // 스케쥴 삭제 ( 스타 삭제 시 사용 )
    func deleteSchedule(_ star: Star) {
        deviceActivityCenter.stopMonitoring([.init(star.identifier.uuidString)])
    }
    
    // 스케쥴 업데이트 ( 스타 수정 시 사용 )
    func updateSchedule(_ star: Star) {
        deviceActivityCenter.stopMonitoring([.init(star.identifier.uuidString)])
        creatSchedule(star: star)
    }
    
    // DeviceActivitySchedule 를 입력받아 스케쥴 모니터링을 시작시킵니다.
    private func setSchedule(name activityName: DeviceActivityName,
                             _ schedule: DeviceActivitySchedule) {
        do {
            try deviceActivityCenter.startMonitoring(activityName,
                                                     during: schedule)
        } catch {
            debugPrint(error.localizedDescription)
        }
        FamilyControlsManager().updateBlockList()
    }
    
}

extension BlockManager {
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
    // 저장된 휴식을 임의로 종료시킬 경우 스케쥴을 중단시킵니다.
    func endRest() {
        deviceActivityCenter.stopMonitoring([.rest])
    }

}

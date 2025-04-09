//
//  DeviceActivityScheduleManager.swift
//  star
//
//  Created by 0-jerry on 4/9/25.
//

import Foundation
import DeviceActivity

struct DeviceActivityScheduleManager {
    
    private let center = DeviceActivityCenter()
        
    // 스타 스케쥴 추가
    func creatSchedule(_ star: Star) {
        center.startMonitoring(star)
    }
    
    // 스케쥴 삭제 ( 스타 삭제 시 사용 )
    func deleteSchedule(_ star: Star) {
        let name = DeviceActivityName(from: star)
        
        center.stopMonitoring([name])
    }
    
    // 스케쥴 업데이트 ( 스타 수정 시 사용 )
    func updateSchedule(_ star: Star) {
        deleteSchedule(star)
        creatSchedule(star)
    }
}

extension DeviceActivityScheduleManager {
    // 휴식 스케쥴 추가
    func rest() {
        guard let restEndTime = RestManager().restEndTimeGet() else { return }
        
        let startTime = DateComponents(from: .now.addingTimeInterval(-900))
        let endTime = DateComponents(from: restEndTime)
        
        let blockSchedule = DeviceActivitySchedule(
            intervalStart: startTime,
            intervalEnd: endTime,
            repeats: false
        )
        
        center.rest(blockSchedule)
    }
    // 저장된 휴식을 임의로 종료시킬 경우 스케쥴을 중단시킵니다.
    func endRest() {
        center.endRest()
    }
}

private extension DateComponents {
    init(from date: Date) {
        let dateComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second,
            .nanosecond
        ]
        
        self = Calendar.current.dateComponents(dateComponents, from: date)
    }
}

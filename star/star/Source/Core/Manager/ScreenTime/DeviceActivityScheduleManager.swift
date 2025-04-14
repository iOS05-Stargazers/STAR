//
//  DeviceActivityScheduleManager.swift
//  star
//
//  Created by 0-jerry on 4/9/25.
//

import Foundation
import DeviceActivity

// DeviceActivitySchedule 관리자
// Star 스케줄 등록, 삭제, 업데이트
// 휴식 스케줄을 등록, 삭제
struct DeviceActivityScheduleManager {
    
    private let center = DeviceActivityCenter()
        
    // Star 스케줄 추가
    func createSchedule(_ star: Star) {
        center.startMonitoring(star)
    }
    
    // Star 스케줄 삭제
    func deleteSchedule(_ star: Star) {
        let name = DeviceActivityName(from: star)
        
        center.stopMonitoring([name])
    }
    
    // 스케줄 업데이트
    func updateSchedule(_ star: Star) {
        deleteSchedule(star)
        createSchedule(star)
    }
    
    // 휴식 스케줄 추가
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
    // 저장된 휴식을 임의로 종료시킬 경우 스케줄을 중단시킵니다.
    func endRest() {
        center.endRest()
    }
    
    func createBreak(of star: Star) {
        guard let breakEndTime = StarBreakManager().breakEndTime(of: star) else { return }

        let startTime = DateComponents(from: .now.addingTimeInterval(-1500))
        let endTime = DateComponents(from: breakEndTime.addingTimeInterval(-30))
        
        let breakSchedule = DeviceActivitySchedule(
            intervalStart: startTime,
            intervalEnd: endTime,
            repeats: false
        )
        
        let name = DeviceActivityName(forBreak: star)
        
        center.setMonitoring(name, during: breakSchedule)
    }
    
    func deleteBreak(of star: Star) {
        let name = DeviceActivityName(forBreak: star)
        
        center.stopMonitoring([name])
    }
}

private extension DateComponents {
    init(from date: Date) {
        let dateComponents: Set<Calendar.Component> = Calendar.Component.forRawDate
        
        self = Calendar.current.dateComponents(dateComponents, from: date)
    }
}

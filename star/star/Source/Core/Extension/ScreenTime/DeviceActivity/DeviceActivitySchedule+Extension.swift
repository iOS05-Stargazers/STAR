//
//  DeviceActivitySchedule+Extension.swift
//  star
//
//  Created by 0-jerry on 4/9/25.
//

import Foundation
import DeviceActivity

extension DeviceActivitySchedule {
    init(from star: Star) {
        let start = DateComponents(from: star.schedule.startTime)
        let end = DateComponents(from: star.schedule.endTime)
        
        self = .init(intervalStart: start,
                     intervalEnd: end,
                     repeats: true)
    }
    // 스타 중단을 위한 스케줄 생성자
    init?(forBreak star: Star) {
        guard let endDate = StarBreakManager().breakEndTime(of: star) else {
            return nil
        }
        
        let start = DateComponents(from: .now)
        let end = DateComponents(from: endDate)
        
        self = .init(intervalStart: start,
                     intervalEnd: end,
                     repeats: false)
    }
}

private extension DateComponents {
    init(from starTime: StarTime) {
        self = DateComponents(hour: starTime.hour,
                              minute: starTime.minute)
    }
    
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

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
}

private extension DateComponents {
    init(from starTime: StarTime) {
        self = DateComponents(hour: starTime.hour,
                              minute: starTime.minute)
    }
}

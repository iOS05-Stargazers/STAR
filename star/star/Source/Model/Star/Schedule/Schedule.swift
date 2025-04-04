//
//  Schedule.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - Schedule

struct Schedule: Codable {
    
    let startTime: StarTime
    let endTime: StarTime
    let weekDays: Set<WeekDay>
    
    func starTimeDateComponentsList() -> [DateComponents] {
        return weekDays.compactMap {
            DateComponents(hour: startTime.hour,
                           minute: startTime.minute,
                           weekday: $0.rawValue)
        }
    }
    
    func finishTimeDateComponentsList() -> [DateComponents] {
        let isNextDay: Bool = startTime > endTime
        return weekDays.compactMap {
            guard let weekDayRawValue = isNextDay ? $0.next()?.rawValue : $0.rawValue else { return nil }
            return DateComponents(hour: endTime.hour,
                           minute: endTime.minute,
                           weekday: weekDayRawValue)
        }
    }
}

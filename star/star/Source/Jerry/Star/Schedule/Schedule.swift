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
    let finishTime: StarTime
    let weekDays: Set<WeekDay>
    
    func starTimeDateComponentsList() -> [DateComponents] {
        return weekDays.compactMap {
            DateComponents(hour: startTime.hour,
                           minute: startTime.minute,
                           weekday: $0.rawValue)
        }
    }
    
    func finishTimeDateComponentsList() -> [DateComponents] {
        return weekDays.compactMap {
            DateComponents(hour: finishTime.hour,
                           minute: finishTime.minute,
                           weekday: $0.rawValue)
        }
    }
}

extension Schedule: TestDescriptionConvertible {
    var testDescription: String {
        let startTime = startTime.testDescription
        let finishTime = finishTime.testDescription
        let weekDays = weekDays
            .sorted(by: <)
            .map { $0.korean }
            .joined(separator: ", ")
        
        return """
                <Schedule>
                startTime: \(startTime)
                finishTime: \(finishTime)
                weekDays: \(weekDays)
                """
    }
}

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
}

extension Schedule: TestDescriptionConvertible {
    var testDescription: String {
        let startTime = startTime.testDescription
        let endTime = endTime.testDescription
        let weekDays = weekDays
            .sorted(by: <)
            .map { $0.korean }
            .joined(separator: ", ")
        
        return """
                <Schedule>
                startTime: \(startTime)
                endTime: \(endTime)
                weekDays: \(weekDays)
                """
    }
}

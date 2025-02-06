//
//  Schedule.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - Schedule


import Foundation

struct Schedule: Codable {
    var startTime: StarTime
    var endTime: StarTime
    var weekDays: Set<WeekDay>
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

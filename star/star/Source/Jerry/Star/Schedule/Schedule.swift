//
//  Schedule.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - Schedule

struct Schedule {
    let startTime: StarTime
    let finishTime: StarTime
    let weekDays: Set<WeekDay>
}

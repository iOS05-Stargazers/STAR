//
//  WeekDay.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - WeekDay

enum WeekDay: Int, Hashable, CaseIterable {
    case mon = 0
    case tue
    case wed
    case thu
    case fri
    case sat
    case sun = 6
    
    var korean: String {
        WeekDayFormatter.korean(self)
    }
    
    static func allKoreanCases() -> [String] {
        WeekDay.allCases.map { $0.korean }
    }
    
    init?(from date: Date) {
        // 일요일 == 1, 토요일 == 7
        let calender = Calendar.current
        let index = ( calender.component(.weekday, from: date) + 5 ) % 7
        guard let weekDay = WeekDay(rawValue: index) else { return nil }
        self = weekDay
    }
}

extension WeekDay: Comparable {
    static func < (lhs: WeekDay, rhs: WeekDay) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

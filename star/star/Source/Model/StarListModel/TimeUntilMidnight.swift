//
//  TimeUntilMidnight.swift
//  star
//
//  Created by 서문가은 on 2/5/25.
//

import Foundation

struct TimeUntilMidnight {
    // 다음 날 자정까지 남은 시간 구하는 메서드
    static func timeUntilMidnight() -> TimeInterval? {
        let now = Date.now
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)

        let tomorrow = calendar.date(from: DateComponents(
            year: year,
            month: month,
            day: day + 1,
            hour: 0,
            minute: 0,
            second: 0
        )) // 다음 날 자정
        return tomorrow?.timeIntervalSince(now) // 다음 날 자정까지 남은 시간 반환
    }
}

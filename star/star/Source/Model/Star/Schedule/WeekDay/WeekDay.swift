//
//  WeekDay.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - WeekDay

enum WeekDay: Int, Hashable, CaseIterable, Codable {
    case sun = 1
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat = 7
    
    // UI 표시용 현지화 문자열
    var localizedString: String {
        WeekDayFormatter.localized(self)
    }
    
    // 저장용 한국어 문자열
    var storageKorean: String {
        WeekDayFormatter.storageKorean(self)
    }
    
    // 전체 요일에 대한 현지화된 문자열을 배열로 반환
    static func allLocalizedCases() -> [String] {
        WeekDay
            .allCases
            .sorted(by: <)
            .map { $0.localizedString }
    }
    
    // Date 타입을 통한 요일 값 생성
    init?(from date: Date) {
        // 일요일 == 1, 토요일 == 7
        let calender = Calendar.current
        let index = calender.component(.weekday, from: date)
        guard let weekDay = WeekDay(rawValue: index) else { return nil }
        self = weekDay
    }
}

// 정렬을 위한 Comparable 채택
extension WeekDay: Comparable {
    
    static func < (lhs: WeekDay, rhs: WeekDay) -> Bool {
        func compareValue(_ int: Int) -> Int {
            return ( int + 5 ) % 7
        }
        return compareValue(lhs.rawValue) < compareValue(rhs.rawValue)
    }
}

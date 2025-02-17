//
//  WeekDayFormatter.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - WeekDayFormatter

struct WeekDayFormatter {
    
    static func korean(_ weekDay: WeekDay) -> String {
        switch weekDay {
        case .mon:
            return "월"
        case .tue:
            return "화"
        case .wed:
            return "수"
        case .thu:
            return "목"
        case .fri:
            return "금"
        case .sat:
            return "토"
        case .sun:
            return "일"
        }
    }
}

//
//  WeekDayFormatter.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - WeekDayFormatter

struct WeekDayFormatter {
    // 저장용 한국어 문자열
    static func storageKorean(_ weekDay: WeekDay) -> String {
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
    
    // UI 표시용 현지화 문자열
    static func localized(_ weekDay: WeekDay) -> String {
        switch weekDay {
        case .mon:
            return NSLocalizedString("monday", comment: "")
        case .tue:
            return NSLocalizedString("tuesday", comment: "")
        case .wed:
            return NSLocalizedString("wednesday", comment: "")
        case .thu:
            return NSLocalizedString("thursday", comment: "")
        case .fri:
            return NSLocalizedString("friday", comment: "")
        case .sat:
            return NSLocalizedString("saturday", comment: "")
        case .sun:
            return NSLocalizedString("sunday", comment: "")
        }
    }
}

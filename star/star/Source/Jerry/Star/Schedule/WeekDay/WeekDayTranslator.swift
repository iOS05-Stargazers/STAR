//
//  WeekDayTranslator.swift
//  star
//
//  Created by 0-jerry on 1/23/25.
//

import Foundation

struct WeekDayTranslator {
    static func weekDays(_ weekDays: Set<WeekDay>) -> String {
        return weekDays.sorted(by: <)
            .map { $0.korean }
            .joined(separator: ", ")
    }
}

//
//  WeekDayTranslator.swift
//  star
//
//  Created by 0-jerry on 1/23/25.
//

struct WeekDayTranslator {
    // CoreData 의 저장을 형식 고려한 형변환 메서드
    static func weekDays(_ weekDays: Set<WeekDay>) -> String {
        return weekDays.sorted(by: <)
            .map { $0.korean }
            .joined(separator: ", ")
    }
}

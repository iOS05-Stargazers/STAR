//
//  WeekDayTranslator.swift
//  star
//
//  Created by 0-jerry on 1/23/25.
//

struct WeekDayTranslator {
    // CoreData 저장을 위한 형변환 메서드 - 한국어로 저장
    static func weekDays(_ weekDays: Set<WeekDay>) -> String {
        return weekDays.sorted(by: <)
            .map { $0.storageKorean }  // 저장용 한국어 사용
            .joined(separator: ", ")
    }
}

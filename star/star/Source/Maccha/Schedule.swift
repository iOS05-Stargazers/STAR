//
//  Schedule.swift
//  star
//
//  Created by t0000-m0112 on 2025-02-03.
//

import Foundation
import FamilyControls

// MARK: - 스케쥴 모델 (이름, 앱 잠금, 요일, 시작/종료 시간)
struct Schedule: Codable {
    var name: String = ""
    var appLock: FamilyActivitySelection = FamilyActivitySelection()
    var weekDays: Set<WeekDay> = [] // 선택된 요일들
    var startTime: Date = Date()
    var endTime: Date = Date().addingTimeInterval(3600) // 기본: 현재 시간 + 60분
    
    var formattedWeekDays: String {
        return WeekDayTranslator.weekDays(weekDays)
    }
}

// MARK: - 스케쥴을 RawRepresentable로 변환하여 AppStorage에 저장할 수 있도록 함
extension Schedule: RawRepresentable {
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let schedule = try? JSONDecoder().decode(Schedule.self, from: data)
        else {
            return nil
        }
        self = schedule
    }
    
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let string = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }
        return string
    }
}

// MARK: - TestDescriptionConvertible
extension Schedule: TestDescriptionConvertible {
    var testDescription: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let startTimeString = formatter.string(from: startTime)
        let finishTimeString = formatter.string(from: endTime)
        
        let appLockDescription = appLock.rawValue

        return """
        Schedule:
          - Name: \(name)
          - AppLock: \(appLockDescription)
          - WeekDays: \(formattedWeekDays)
          - Start Time: \(startTimeString)
          - Finish Time: \(finishTimeString)
        """
    }
}

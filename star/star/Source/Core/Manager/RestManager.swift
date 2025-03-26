//
//  BreakManager.swift
//  star
//
//  Created by 0-jerry on 3/26/25.
//

import Foundation

struct RestManager {

    private let container = UserDefaults.appGroups

    private enum Key {
        static let restEndTime = "restEndTime"
    }
    
    // CREATE/UPDATE
    func restEndTimeSet(_ value: Int) -> Date? {
        let endTime = endTimeCalculate(minutes: value)
        container.set(endTime, forKey: Key.restEndTime)
        return endTime
    }
    
    // READ
    func restEndTimeGet() -> Date? {
        guard let endTime = container.value(forKey: Key.restEndTime) as? Date,
              endTime >= .now else {
            restEndTimeDelete()
            return nil }
        return endTime
    }
    
    // DELETE
    func restEndTimeDelete() {
        container.removeObject(forKey: Key.restEndTime)
    }
    
    // 휴식 종료시간 계산
    private func endTimeCalculate(minutes: Int) -> Date? {
        let calendar = Calendar.current
        let endTime = calendar.date(byAdding: .minute, value: minutes, to: Date())
        return endTime
    }
}

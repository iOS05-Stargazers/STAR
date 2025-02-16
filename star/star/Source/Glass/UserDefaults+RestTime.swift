//
//  UserDefaults+RestTime.swift
//  star
//
//  Created by 안준경 on 2/12/25.
//

import Foundation

extension UserDefaults {
    enum Key {
        static let restEndTime = "restEndTime"
    }
    
    // CREATE/UPDATE
    func restEndTimeSet(_ value: Int) -> Date? {
        let endTime = endTimeCalculate(minutes: value)
        self.set(endTime, forKey: Key.restEndTime)
        
        return endTime
    }
    
    // READ
    func restEndTimeGet() -> Date? {
        guard let endTime = self.value(forKey: Key.restEndTime) as? Date,
              endTime >= .now else {
            self.set(nil, forKey: Key.restEndTime)
            return nil }
        return endTime
    }
    
    // DELETE
    func restEndTimeDelete() {
        self.removeObject(forKey: Key.restEndTime)
    }
    
    // 휴식 종료시간 계산
    private func endTimeCalculate(minutes: Int) -> Date? {
        let calendar = Calendar.current
        let endTime = calendar.date(byAdding: .minute, value: minutes, to: Date())
        return endTime
    }
    
}

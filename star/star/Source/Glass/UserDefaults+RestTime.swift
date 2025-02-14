//
//  UserDefaults+RestTime.swift
//  star
//
//  Created by 안준경 on 2/12/25.
//

import Foundation

extension UserDefaults {
    
    // CREATE/UPDATE
    func restEndTimeSet(_ value: Int) -> Date? {
        let endTime = endTimeCalculate(minutes: value)
        UserDefaults.appGroups.set(endTime, forKey: "restEndTime")
        
        return endTime
    }
    
    // READ
    func restEndTimeGet() -> Date? {
        guard let endTime = UserDefaults.appGroups.value(forKey: "restEndTime") as? Date,
              endTime >= Date.now else {
            restEndTimeDelete()
            return nil }
        return endTime
    }
    
    // DELETE
    func restEndTimeDelete() {
        UserDefaults.appGroups.removeObject(forKey: "restEndTime")
    }
    
    // 휴식 종료시간 계산
    private func endTimeCalculate(minutes: Int) -> Date? {
        let calendar = Calendar.current
        let endTime = calendar.date(byAdding: .minute, value: minutes, to: Date())
        return endTime
    }
    
}

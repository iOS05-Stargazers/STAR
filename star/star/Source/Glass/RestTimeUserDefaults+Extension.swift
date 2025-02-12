//
//  RestTimeUserDefaults+Extension.swift
//  star
//
//  Created by 안준경 on 2/11/25.
//

import Foundation

extension UserDefaults {
    
    // CREATE/UPDATE
    func restEndTimeSet(_ value: Int) {
        let endTime = endTimeCalculate(minutes: value)
        UserDefaults.standard.set(endTime, forKey: "restEndTime")
    }
    
    // READ
    func restEndTimeGet() -> Date? {
        guard let endTime = UserDefaults.standard.value(forKey: "restEndTime") as? Date else { return nil }
        return endTime
    }
    
    // 휴식 종료시간 계산
    private func endTimeCalculate(minutes: Int) -> Date {
        let calendar = Calendar.current
        let endTime = calendar.date(byAdding: .minute, value: minutes, to: Date()) ?? Date()
        return endTime
    }
    
}


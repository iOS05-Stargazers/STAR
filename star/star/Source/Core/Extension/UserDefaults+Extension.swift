//
//  UserDefaults+Extension.swift
//  star
//
//  Created by 0-jerry on 2/13/25.
//  Created by Eden on 1/26/25.
//  Created by 안준경 on 2/12/25.
//

import Foundation

// MARK: - appGroups

extension UserDefaults {
    
    static let appGroups = {
        guard let appGroups = UserDefaults(suiteName: "group.com.stargazers.star") else {
            fatalError("App Groups UserDefaults None")
        }
        return appGroups
    }()
}

// MARK: - isCoachMarkShown, shouldKeepNotification

extension UserDefaults {
    
    private enum Keys {
        static let isCoachMarkShown = "isCoachMarkShown"
        static let shouldKeepNotification = "shouldKeepNotification"
    }
    
    var isCoachMarkShown: Bool {
        get {
            bool(forKey: Keys.isCoachMarkShown)
        }
        set {
            set(newValue, forKey: Keys.isCoachMarkShown)
        }
    }
    
    var shouldKeepNotification: Bool {
        get {
            bool(forKey: Keys.shouldKeepNotification)
        }
        set {
            set(newValue, forKey: Keys.shouldKeepNotification)
        }
    }
}

// MARK: - restEndTime

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



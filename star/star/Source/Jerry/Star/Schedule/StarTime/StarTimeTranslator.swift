//
//  StarTimeTranslator.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - StarTimeTranslator

struct StarTimeTranslator {
    
    static func starTime(by description: String) -> (hour: Int, minute: Int) {
        let components = description
            .components(separatedBy: ":")
            .compactMap { Int($0) }
        guard components.count == 2 else {
            return (hour: 0, minute: 0)
        }
        let hour = components[0]
        let minute = components[1]
        guard validHour(hour), validMinute(minute) else {
            return (hour: 0, minute: 0)
        }
        return (hour: components[0], minute: components[1])
    }
    
    static func starTime(from date: Date) -> (hour: Int, minute: Int) {
        let hour = currentHour(of: date)
        let minute = currentMinute(of: date)
        return (hour: hour, minute: minute)
    }
    
    static func starTime(hour: Int, minute: Int) -> (hour: Int, minute: Int) {
        let hour = validHour(hour) ? hour : 0
        let minute = validMinute(minute) ? minute : 0
        return (hour: hour, minute: minute)
    }
    
}

// MARK: StarTimeConverter - 내부사용 메서드

extension StarTimeTranslator {
    
    private static func validHour(_ value: Int) -> Bool {
        let hourRange = 0...23
        return hourRange.contains(value)
    }
    
    private static func validMinute(_ value: Int) -> Bool {
        let minuteRange = 0...59
        return minuteRange.contains(value)
    }
    
    private static func currentHour(of date: Date) -> Int {
        return Calendar.current.component(.hour, from: date)
    }
    
    private static func currentMinute(of date: Date) -> Int {
        return Calendar.current.component(.minute, from: date)
    }
    
}

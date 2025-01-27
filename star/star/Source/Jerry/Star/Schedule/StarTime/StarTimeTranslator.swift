//
//  StarTimeTranslator.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - StarTimeTranslator

struct StarTimeTranslator {
    // "HH:mm" 문자열 -> (hour: Int, minute: Int) : StarTime 생성자에서 호출
    static func starTime(by description: String) -> (hour: Int, minute: Int) {
        let components = description
            .components(separatedBy: ":")
            .compactMap { Int($0) }
        // 형식 검증
        guard components.count == 2 else {
            return (hour: 0, minute: 0)
        }
        let hour = components[0]
        let minute = components[1]
        // 범위 검증
        guard validHour(hour), validMinute(minute) else {
            return (hour: 0, minute: 0)
        }
        return (hour: components[0], minute: components[1])
    }
    // Date -> (hour: Int, minute: Int) : StarTime 생성자에서 호출
    static func starTime(from date: Date) -> (hour: Int, minute: Int) {
        let hour = currentHour(of: date)
        let minute = currentMinute(of: date)
        return (hour: hour, minute: minute)
    }
    // (hour: Int, minute: Int) 검증 : StarTime 생성자에서 호출
    static func starTime(hour: Int, minute: Int) -> (hour: Int, minute: Int) {
        let hour = validHour(hour) ? hour : 0
        let minute = validMinute(minute) ? minute : 0
        return (hour: hour, minute: minute)
    }
    
}

// MARK: StarTimeConverter - 내부사용 메서드

extension StarTimeTranslator {
    // Hour 범위 검증 메서드
    private static func validHour(_ value: Int) -> Bool {
        let hourRange = 0...23
        return hourRange.contains(value)
    }
    // Minute 범위 검증 메서드
    private static func validMinute(_ value: Int) -> Bool {
        let minuteRange = 0...59
        return minuteRange.contains(value)
    }
    // Date -> 시간 값을 범위 검증 후 반환 (디폴트: 0)
    private static func currentHour(of date: Date) -> Int {
        let hour = Calendar.current.component(.hour, from: date)
        return validHour(hour) ? hour : 0
    }
    // Date -> 분 값을 범위 검증 후 반환 (디폴트: 0)
    private static func currentMinute(of date: Date) -> Int {
        let minute = Calendar.current.component(.minute, from: date)
        return validMinute(minute) ? minute : 0
    }
    
}

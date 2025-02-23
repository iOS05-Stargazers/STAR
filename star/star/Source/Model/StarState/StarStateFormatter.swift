//
//  StarStateFormatter.swift
//  star
//
//  Created by 0-jerry on 1/27/25.
//

import Foundation
// StarState 형식
struct StarStateFormatter {
    
    enum Style {
        case second
        case minute
        case hour
        case day
        
        init(timeInterval: TimeInterval) {
            let secondMax: Double = 60
            let minuteMax: Double = secondMax * 60
            let hourMax: Double = minuteMax * 24
            
            if timeInterval < secondMax {
                self = .second
            } else if timeInterval < minuteMax {
                self = .minute
            } else if timeInterval < hourMax {
                self = .hour
            } else {
                self = .day
            }
        }
    }
    
    // "0시간 남음" 형식
    static func korean(_ timeInterval: TimeInterval) -> String {
        let style = Style(timeInterval: timeInterval)
        let timeInterval = Int(timeInterval)
        switch style {
        case .second:
            let value = timeInterval
            return secondForm(value)
        case .minute:
            let value = timeInterval / 60
            return minuteForm(value)
        case .hour:
            let value = timeInterval / ( 60 * 60 )
            return hourForm(value)
        case .day:
            let value = timeInterval / ( 60 * 60 * 24 )
            return dayForm(value)
        }
    }
    // "hh:mm:ss" 형식
    static func hhmmss(_ timeInterval: TimeInterval) -> String {
        let timeInterval = Int(timeInterval)
        let hour = timeInterval / ( 60 * 60 ) % 24
        let minute = timeInterval / 60 % 60
        let second = timeInterval % 60
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
    
    private static func secondForm(_ value: Int) -> String {
        String(format: NSLocalizedString("seconds_left", comment: ""), value)
    }
    private static func minuteForm(_ value: Int) -> String {
        String(format: NSLocalizedString("minutes_left", comment: ""), value)
    }

    private static func hourForm(_ value: Int) -> String {
        String(format: NSLocalizedString("hours_left", comment: ""), value)
    }

    private static func dayForm(_ value: Int) -> String {
        String(format: NSLocalizedString("days_left", comment: ""), value)
    }
}

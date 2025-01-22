//
//  StarTimeFormatter.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - StarTimeFormatter

struct StarTimeFormatter {
    
    static func convert(hour: Int, minute: Int) -> String {
        let hour = stringForm(hour)
        let minute = stringForm(minute)
        return String(format: "%@:%@", hour, minute)
    }
    
}

// MARK: StarTimeFormatter - 내부 사용 메서드

extension StarTimeFormatter {
    
    private static func stringForm(_ value: Int) -> String {
        return String(format: "%02d", value)
    }
    
}



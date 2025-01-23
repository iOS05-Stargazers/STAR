//
//  StarTimeFormatter.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation
import Then

// MARK: - StarTimeFormatter

struct StarTimeFormatter {
    
    static func convert(_ starTime: StarTime) -> String {
        let hour = stringForm(starTime.hour)
        let minute = stringForm(starTime.minute)
        return String(format: "%@:%@", hour, minute)
    }
    
}

// MARK: StarTimeFormatter - 내부 사용 메서드

extension StarTimeFormatter {
    
    private static func stringForm(_ value: Int) -> String {
        return String(format: "%02d", value)
    }
    
}

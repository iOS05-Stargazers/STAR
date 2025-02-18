//
//  StarTimeFormatter.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - StarTimeFormatter

struct StarTimeFormatter {
    // "HH:mm" 의 문자열 반환
    static func convert(_ starTime: StarTime) -> String {
        let hour = stringForm(starTime.hour)
        let minute = stringForm(starTime.minute)
        return String(format: "%@:%@", hour, minute)
    }
}

// MARK: StarTimeFormatter - 내부 사용 메서드

extension StarTimeFormatter {
    // 한 자리 수를 "01" 과 같은 두자릿수 문자열로 변환
    private static func stringForm(_ value: Int) -> String {
        return String(format: "%02d", value)
    }
}

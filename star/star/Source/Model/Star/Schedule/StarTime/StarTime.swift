//
//  StarTime.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - StarTime

struct StarTime: Codable {
    // 시간
    let hour: Int
    // 분
    let minute: Int
    // "HH:mm" 문자열
    func strForm() -> String {
        StarTimeFormatter.convert(self)
    }
}

// MARK: StarTime - init

extension StarTime {
    // 스타 생성 및 수정 모달을 통한 입력을 고려한 생성자
    init(date: Date) {
        let starTime = StarTimeTranslator.starTime(from: date)
        self.hour = starTime.hour
        self.minute = starTime.minute
    }
    // HH:mm 문자열을 통한 생성자
    init(from description: String) {
        let starTime = StarTimeTranslator.starTime(by: description)
        self.hour = starTime.hour
        self.minute = starTime.minute
    }
}

extension StarTime: Comparable {
    // 비교 연산 로직
    static func < (lhs: StarTime, rhs: StarTime) -> Bool {
        lhs.strForm() < rhs.strForm()
    }
}

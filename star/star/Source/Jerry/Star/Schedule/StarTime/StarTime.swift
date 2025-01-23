//
//  StarTime.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - StarTime

struct StarTime {
    let hour: Int
    let minute: Int

    init(hour: Int, minute: Int) {
        self = StarTimeTranslator.starTime(hour: hour, minute: minute)
    }
    
    func coreDataForm() -> String {
        StarTimeFormatter.convert(self)
    }
    
}

// MARK: StarTime - init

extension StarTime {

    init(date: Date) {
        self = StarTimeTranslator.starTime(from: date)
    }
    
    init?(from description: String) {
        guard let starTime = StarTimeTranslator.starTime(by: description) else {
            return nil }
        self = starTime
    }
    
}

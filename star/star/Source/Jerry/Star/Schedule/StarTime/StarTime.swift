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
        let starTime = StarTimeTranslator.starTime(hour: hour,
                                                   minute: minute)
        self.hour = starTime.hour
        self.minute = starTime.minute
    }
    
    func coreDataForm() -> String {
        StarTimeFormatter.convert(self)
    }
    
}

// MARK: StarTime - init

extension StarTime {

    init(date: Date) {
        let starTime = StarTimeTranslator.starTime(from: date)
        self.hour = starTime.hour
        self.minute = starTime.minute
    }
    
    init(from description: String) {
        let starTime = StarTimeTranslator.starTime(by: description)
        self.hour = starTime.hour
        self.minute = starTime.minute
    }
    
}

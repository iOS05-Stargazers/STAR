//
//  StarTime.swift
//  star
//
//  Created by 0-jerry on 1/22/25.
//

import Foundation

// MARK: - StarTime

struct StarTime {
    private let hour: Int
    private let minute: Int

    init(hour: Int, minute: Int) {
        self = StarTimeConverter.starTime(hour: hour, minute: minute)
    }
    
    func coreDataForm() -> String {
        StarTimeFormatter.convert(hour: hour, minute: minute)
    }
}

// MARK: StarTime - init

extension StarTime {

    init(date: Date) {
        self = StarTimeConverter.starTime(from: date)
    }
    
    init?(from description: String) {
        guard let starTime = StarTimeConverter.starTime(by: description) else {
            return nil }
        self = starTime
    }
    
}

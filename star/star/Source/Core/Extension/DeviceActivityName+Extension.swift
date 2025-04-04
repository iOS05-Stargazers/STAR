//
//  DeviceActivityName+Extension.swift
//  star
//
//  Created by 0-jerry on 2/13/25.
//

import DeviceActivity

extension DeviceActivityName {
    
    static let rest = Self("rest")
    
    init(from star: Star) {
        self = .init(star.identifier.uuidString)
    }
}


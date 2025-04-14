//
//  DeviceActivityName+Extension.swift
//  star
//
//  Created by 0-jerry on 2/13/25.
//

import DeviceActivity

extension DeviceActivityName {
    
    static let rest = Self("rest")
    // Star 의 UUID의 String 값을 통해 ID 매칭
    init(from star: Star) {
        self = .init(star.identifier.uuidString)
    }
    
    init(forBreak star: Star) {
        let key = StarBreakIDFormmater.key(of: star)
        self = .init(key)
    }
}


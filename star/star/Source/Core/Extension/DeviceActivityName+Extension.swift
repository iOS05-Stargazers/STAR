//
//  DeviceActivityName+Extension.swift
//  star
//
//  Created by 0-jerry on 2/13/25.
//

import Foundation
import ManagedSettings
import DeviceActivity

extension DeviceActivityName {
    static let daily = Self("daily")
    
    static func make(_ name: String) -> DeviceActivityName {
        return Self(name)
    }
}

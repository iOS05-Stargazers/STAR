//
//  UserDefaults+Extension.swift
//  star
//
//  Created by Eden on 1/26/25.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let isCoachMarkShown = "isCoachMarkShown"
    }
    
    var isCoachMarkShown: Bool {
        get {
            bool(forKey: Keys.isCoachMarkShown)
        }
        set {
            set(newValue, forKey: Keys.isCoachMarkShown)
        }
    }
}


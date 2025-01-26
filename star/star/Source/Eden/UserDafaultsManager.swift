//
//  UserDafaultsManager.swift
//  star
//
//  Created by Eden on 1/26/25.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    private enum Keys {
        static let isCoachMarkShown = "isCoachMarkShown"
    }
    
    var isCoachMarkShown: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.isCoachMarkShown)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isCoachMarkShown)
        }
    }
}

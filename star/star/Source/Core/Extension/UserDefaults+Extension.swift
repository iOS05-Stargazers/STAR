//
//  UserDefaults+Extension.swift
//  star
//
//  Created by 0-jerry on 2/13/25.
//  Created by Eden on 1/26/25.
//  Created by 안준경 on 2/12/25.
//

import Foundation

// MARK: - appGroups

extension UserDefaults {
    
    static let appGroups = {
        guard let appGroups = UserDefaults(suiteName: "group.com.stargazers.star") else {
            fatalError("App Groups UserDefaults None")
        }
        return appGroups
    }()
}

// MARK: - isCoachMarkShown, shouldKeepNotification, isFamilyControlsRefactored

extension UserDefaults {
    
    private enum Keys {
        static let isCoachMarkShown = "isCoachMarkShown"
        static let shouldKeepNotification = "shouldKeepNotification"
        static let isFamilyControlsRefactored = "isFamilyControlsRefactored"
    }
    
    var isCoachMarkShown: Bool {
        get {
            bool(forKey: Keys.isCoachMarkShown)
        }
        set {
            set(newValue, forKey: Keys.isCoachMarkShown)
        }
    }
    
    // TODO: 1.0.5 정도 되면 삭제
    
    var shouldKeepNotification: Bool {
        get {
            bool(forKey: Keys.shouldKeepNotification)
        }
        set {
            set(newValue, forKey: Keys.shouldKeepNotification)
        }
    }
    
    var isFamilyControlsRefactored: Bool {
        get {
            bool(forKey: Keys.isFamilyControlsRefactored)
        }
        set {
            set(newValue, forKey: Keys.isFamilyControlsRefactored)
        }
    }
}

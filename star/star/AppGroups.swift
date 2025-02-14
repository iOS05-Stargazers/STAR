//
//  AppGroups.swift
//  star
//
//  Created by 0-jerry on 2/13/25.
//

import Foundation

extension UserDefaults {
    static let appGroups = {
        guard let appGroups = UserDefaults(suiteName: "group.com.stargazers.star") else {
            fatalError("App Groups UserDefaults None")
        }
        return appGroups
    }()
}

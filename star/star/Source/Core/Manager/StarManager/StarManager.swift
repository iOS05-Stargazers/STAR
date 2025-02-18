//
//  StarManager.swift
//  star
//
//  Created by 0-jerry on 1/30/25.
//

import Foundation

final class StarManager {
    
    static let shared = StarManager()
    private init() {}
    
    private let userDefaultsManager = StarUserDefaultsManager.shared
    
    func create(_ star: Star) {
        userDefaultsManager.create(star)
    }
    
    func read() -> [Star] {
        userDefaultsManager.read()
    }
    
    func delete(_ star: Star) {
        userDefaultsManager.delete(star)
    }
    
    func update(_ star: Star) {
        userDefaultsManager.update(star)
    }
    
}

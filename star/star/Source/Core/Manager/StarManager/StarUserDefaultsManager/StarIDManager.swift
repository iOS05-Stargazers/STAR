//
//  StarIDManager.swift
//  star
//
//  Created by 0-jerry on 2/4/25.
//

import Foundation

/// StarID 
struct StarIDManager {
    
    private enum Key {
        static let identifiers = "identifiers"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    var starIDList: [UUID] {
        return identifiers()
    }
    
    // ID 목록 추가하기
    func appendID(_ id: UUID) {
        var identifiers = identifiers()
        identifiers.append(id)
        let keys = identifiers.map { StarIDFormatter.key($0) }
        
        userDefaults.setValue(keys, forKey: Key.identifiers)
    }
    // ID 목록 제거하기
    func removeID(_ id: UUID) {
        let identifiers = identifiers()
            .filter { $0 != id }
            .map { StarIDFormatter.key($0) }
        
        userDefaults.setValue(identifiers, forKey: Key.identifiers)
    }
    // ID 목록 불러오기
    private func identifiers() -> [UUID] {
        let stringIDs = (userDefaults.stringArray(forKey: Key.identifiers) ?? []) as [String]
        return stringIDs.compactMap { StarIDFormatter.uuid($0) }
    }
}

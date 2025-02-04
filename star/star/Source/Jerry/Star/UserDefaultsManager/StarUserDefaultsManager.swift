//
//  UserDefaultsManager.swift
//  star
//
//  Created by 0-jerry on 2/3/25.
//

import Foundation

/// UserDefaults 를 통한 Star 데이터 CRUD 지원 (Singleton)
final class StarUserDefaultsManager {
    
    private enum Key {
        static let identifiers = "identifiers"
    }
    
    static let shared = StarUserDefaultsManager()
    
    private init(_ userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        self.starIDManager = StarIDManager(userDefaults: userDefaults)
    }
    
    private let userDefaults: UserDefaults
    
    private let starIDManager: StarIDManager
    
    func create(_ star: Star) {
        guard let data = star.jsonData() else {
            print("\(star.title) - 데이터 저장 실패")
            return
        }
        
        let id = star.identifier
        starIDManager.appendID(id)
        userDefaults.set(data, forKey: StarIDFormatter.key(id))
    }
    
    func read() -> [Star] {
        return starIDManager.starIDList.compactMap { star($0) }
    }
    
    func update(_ star: Star) {
        let id = star.identifier
        guard let data = star.jsonData() else {
            print("\(star.title) - 데이터 저장 실패")
            return }
        
        userDefaults.set(data, forKey: StarIDFormatter.key(id))
    }
    
    func delete(_ star: Star) {
        let id = star.identifier
        starIDManager.removeID(id)
        userDefaults.set(nil, forKey: StarIDFormatter.key(id))
    }
    // 전체 삭제
    func reset() {
        starIDManager.starIDList.forEach { delete(id: $0) }
    }


    private func delete(id: UUID) {
        guard let star = star(id) else { return }
        delete(star)
        starIDManager.removeID(id)
    }
    
    private func star(_ id: UUID) -> Star? {
        guard let data = userDefaults.data(forKey: StarIDFormatter.key(id)),
              let star = Star(from: data) else { return nil }
        
        return star
    }
    
}

struct StarUserDefaultsManagerTester {
    
    let manager = StarUserDefaultsManager.shared
    
    func test() {
        
        print("======CREATE TEST======")
        manager.create(MockData.ongingOneHour)
        manager.create(MockData.pendingOneDay)
        printWhole()
        print("=======================\n\n\n")

        print("======DELETE TEST======")
        manager.delete(MockData.ongingOneHour)
        manager.delete(MockData.pendingOneDay)
        printWhole()
        print("=======================\n\n\n")
        
        print("======UPDATE TEST======")
        manager.create(MockData.beforeUpdate)
        printWhole()
        manager.update(MockData.afterUpdate)
        printWhole()
        print("=======================\n\n\n")

        manager.reset()
    }
    
    private func printWhole() {
        var description = manager.read().map { $0.testDescription }.joined(separator: "\n\n")
        description = description != "" ? description : "데이터 없음"
        print("\n\(description)\n")
    }
}

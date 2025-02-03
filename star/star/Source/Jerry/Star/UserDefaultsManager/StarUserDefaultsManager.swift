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
    }
    
    private let header = "[STAR]"
    
    private let userDefaults: UserDefaults
    
    func create(_ star: Star) {
        guard let data = star.jsonData() else {
            print("\(star.title) - 데이터 저장 실패")
            return
        }
        
        let id = star.identifier
        appendID(id)
        userDefaults.set(data, forKey: key(id))
    }
    
    func read() -> [Star] {
        return identifiers().compactMap { star($0) }
    }
    
    func update(_ star: Star) {
        let id = star.identifier
        guard let data = star.jsonData() else {
            print("\(star.title) - 데이터 저장 실패")
            return }
        
        userDefaults.set(data, forKey: key(id))
    }
    
    func delete(_ star: Star) {
        let id = star.identifier
        removeID(id)
        userDefaults.set(nil, forKey: key(id))
    }
    // 전체 삭제
    func reset() {
        identifiers().forEach { delete(id: $0) }
    }
    
    func printWhole() {
        var description = read().map { $0.testDescription }.joined(separator: "\n\n")
        description = description != "" ? description : "데이터 없음"
        print("\n\(description)\n")
    }
    
    func test() {
        print("======CREATE TEST======")
        self.create(MockData.ongingOneHour)
        self.create(MockData.pendingOneDay)
        self.printWhole()
        print("=======================\n\n\n")

        print("======DELETE TEST======")
        self.delete(MockData.ongingOneHour)
        self.delete(MockData.pendingOneDay)
        self.printWhole()
        print("=======================\n\n\n")
        
        print("======UPDATE TEST======")
        self.create(MockData.beforeUpdate)
        self.printWhole()
        self.update(MockData.afterUpdate)
        self.printWhole()
        print("=======================\n\n\n")

        self.reset()
    }
    
    private func delete(id: UUID) {
        guard let star = star(id) else { return }
        delete(star)
        removeID(id)
    }
    
    private func star(_ id: UUID) -> Star? {
        guard let data = userDefaults.data(forKey: key(id)),
              let star = Star(from: data) else { return nil }
        
        return star
    }
    
}

// MARK: - ID 관련 메서드

extension StarUserDefaultsManager {
    // ID 목록 추가하기
    private func appendID(_ id: UUID) {
        var identifiers = identifiers()
        identifiers.append(id)
        let keys = identifiers.map { key($0) }
        
        userDefaults.setValue(keys, forKey: Key.identifiers)
    }
    // ID 목록 제거하기
    private func removeID(_ id: UUID) {
        let identifiers = identifiers()
            .filter { $0 != id }
            .map { key($0) }
        
        userDefaults.setValue(identifiers, forKey: Key.identifiers)
    }
    // ID 목록 불러오기
    private func identifiers() -> [UUID] {
        let stringIDs = (userDefaults.stringArray(forKey: Key.identifiers) ?? []) as [String]
        return stringIDs.compactMap { uuid($0) }
    }
    // UUID -> key(String) 변환
    private func key(_ id: UUID) -> String {
        let uuidString = id.uuidString
        let key = String(format: "%@:%@", header, uuidString)
        return key
    }
    
    private func uuid(_ key: String) -> UUID? {
        let components = key.components(separatedBy: ":")
        guard components.count == 2,
              components[0] == header,
              let uuid = UUID(uuidString: components[1]) else { return nil }
        
        return uuid
    }
}

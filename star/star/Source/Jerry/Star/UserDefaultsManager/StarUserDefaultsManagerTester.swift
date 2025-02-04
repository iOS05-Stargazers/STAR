//
//  StarUserDefaultsManagerTester.swift
//  star
//
//  Created by 0-jerry on 2/4/25.
//

import Foundation

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

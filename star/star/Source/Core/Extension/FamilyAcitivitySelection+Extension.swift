//
//  FamilyAcitivitySelection+Extension.swift
//  star
//
//  Created by t0000-m0112 on 2025-02-11.
//

import Foundation
import FamilyControls
import ManagedSettings

// MARK: - FamilyActivitySelection Parser
extension FamilyActivitySelection: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else { return nil }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else { return "[]" }
        return result
    }
}

// 데이터 리프레쉬
extension FamilyActivitySelection {
    
    static func refreshBlockList() {
        let store = ManagedSettingsStore()

        var ongoingSelection = FamilyActivitySelection()
        
        StarManager.shared.read()
            .filter { $0.state().style == .ongoing }
            .map { $0.blockList }
            .forEach { ongoingSelection.add($0) }
        
        store.shield.applicationCategories = .specific(ongoingSelection.categoryTokens)
        store.shield.applications = ongoingSelection.applicationTokens
        store.shield.webDomains = ongoingSelection.webDomainTokens
    }
    
    private mutating func add(_ selection: FamilyActivitySelection) {
        self.applicationTokens = applicationTokens.union(selection.applicationTokens)
        self.categoryTokens = categoryTokens.union(selection.categoryTokens)
        self.webDomainTokens = webDomainTokens.union(selection.webDomainTokens)
    }

}

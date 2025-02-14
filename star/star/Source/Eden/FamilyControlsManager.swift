//
//  FamilyControlsManager.swift
//  star
//
//  Created by Eden on 1/27/25.
//

import Foundation
import FamilyControls
import ManagedSettings

struct FamilyControlsManager {
    
    let center =  AuthorizationCenter.shared
    
    func requestAuthorization(completionHandler: @escaping (() -> Void)) {
        Task {
            do {
                try await center.requestAuthorization(for: FamilyControlsMember.individual)
                print("스크린타임 권한 설정 성공")
                completionHandler()
            } catch {
                print("권한 설정 실패 \(error.localizedDescription)")
                completionHandler()
            }
        }
    }
    
}

extension FamilyControlsManager {
    
    static func updateList() {
        if UserDefaults.appGroups.restEndTimeGet() == nil {
            refreshBlockList()
        } else {
            clearList()
        }
    }
    
    private static func clearList() {
        let store = ManagedSettingsStore()

        store.shield.applicationCategories = .specific([])
        store.shield.applications = []
        store.shield.webDomains = []
    }
    
    private static func refreshBlockList() {
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
    
}

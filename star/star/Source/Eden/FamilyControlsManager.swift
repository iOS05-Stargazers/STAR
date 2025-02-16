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
    
    private let center =  AuthorizationCenter.shared
    
    private let store = ManagedSettingsStore()
    
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
    
    func updateBlockList() {
        let onRest: Bool = ( UserDefaults.appGroups.restEndTimeGet() != nil )
        
        onRest ? clearBlockList() : refreshBlockList()
    }
    
    private func refreshBlockList() {

        var ongoingSelection = FamilyActivitySelection()
        
        StarManager.shared.read()
            .filter { $0.state().style == .ongoing }
            .map { $0.blockList }
            .forEach { ongoingSelection.add($0) }
        
        setSelection(ongoingSelection)
    }
    
    private func clearBlockList() {
        setSelection(.init())
    }
    
    private func setSelection(_ selection: FamilyActivitySelection) {
        store.shield.applicationCategories = .specific(selection.categoryTokens)
        store.shield.applications = selection.applicationTokens
        store.shield.webDomains = selection.webDomainTokens
    }
}

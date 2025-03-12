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
                completionHandler()
            } catch {
                completionHandler()
            }
        }
    }
}

extension FamilyControlsManager {
    // 앱 리스트 업데이트
    func updateBlockList() {
        refreshBlockList()
    }
    // 휴식중이 아닌 경우, ongoing 상태인 스타들의 리스트를 취합해 앱 잠금 리스트 업데이트 
    private func refreshBlockList() {
        var ongoingSelection = FamilyActivitySelection()
        
        StarManager.shared.read()
            .filter { $0.state().style == .ongoing }
            .map { $0.blockList }
            .forEach { ongoingSelection.add($0) }
        
        setSelection(ongoingSelection)
    }
    // 휴식중인 경우, 앱 잠금 리스트 비우기
    private func clearBlockList() {
        setSelection(.init())
    }
    // 앱 잠금 리스트를 입력받아 업데이트
    private func setSelection(_ selection: FamilyActivitySelection) {
        store.shield.applicationCategories = .specific(selection.categoryTokens)
        store.shield.applications = selection.applicationTokens
        store.shield.webDomains = selection.webDomainTokens
    }
}

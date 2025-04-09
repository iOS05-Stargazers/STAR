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

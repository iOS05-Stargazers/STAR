//
//  FamilyControlsManager.swift
//  star
//
//  Created by Eden on 1/27/25.
//

import Foundation
import FamilyControls

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
    
    static func refreshList() {
        FamilyActivitySelection.refreshBlockList()
    }
    
}

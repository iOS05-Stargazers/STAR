//
//  ShieldSettings+Extension.swift
//  star
//
//  Created by 0-jerry on 4/9/25.
//

import FamilyControls
import ManagedSettings

extension ShieldSettings {
    // 블록 리스트 설정
    mutating func setBlockList(_ familyActivitySelection: FamilyActivitySelection) {
        applicationCategories = .specific(familyActivitySelection.categoryTokens)
        applications = familyActivitySelection.applicationTokens
        webDomains = familyActivitySelection.webDomainTokens
    }
    // 블록 리스트 삭제
    mutating func clearBlockList() {
        applicationCategories = .specific([])
        applications = []
        webDomains = []
    }
}

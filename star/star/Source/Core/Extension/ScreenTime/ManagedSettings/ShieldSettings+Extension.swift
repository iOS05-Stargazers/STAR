//
//  ShieldSettings+Extension.swift
//  star
//
//  Created by 0-jerry on 4/9/25.
//

import FamilyControls
import ManagedSettings

extension ShieldSettings {
    
    mutating func setList(_ familyActivitySelection: FamilyActivitySelection) {
        applicationCategories = .specific(familyActivitySelection.categoryTokens)
        applications = familyActivitySelection.applicationTokens
        webDomains = familyActivitySelection.webDomainTokens
    }
}

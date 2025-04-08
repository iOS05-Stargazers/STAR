//
//  ManagedSettingsStore+Extension.swift
//  star
//
//  Created by 0-jerry on 4/9/25.
//

import Foundation
import FamilyControls
import ManagedSettings

extension ManagedSettingsStore {
    
    func setShield(_ star: Star) {
        let appBlockList = star.blockList
        shield.setList(appBlockList)
    }
    
}

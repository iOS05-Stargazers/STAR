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
    // 스타 블록 리스트 설정
    func setShield(_ star: Star) {
        let appBlockList = star.blockList
        shield.setBlockList(appBlockList)
    }
    // 블록 리스트 삭제
    func clearShield() {
        shield.clearBlockList()
    }
}

// ManagedSettingsStore 의 ID 형식
extension ManagedSettingsStore.Name {
    // Star 의 UUID의 String 값을 통해 ID 매칭 
    init(from star: Star) {
        let identifier = star.identifier.uuidString
        self = .init(identifier)
    }
}

//
//  ManagedSettingsStoreManager.swift
//  star
//
//  Created by 0-jerry on 4/9/25.
//

import Foundation

import DeviceActivity
import FamilyControls
import ManagedSettings

// 블록 리스트를 관리 ( star 를 로드해 업데이트 )
struct ManagedSettingsStoreManager {
    
    private var stars: [Star] {
        StarManager.shared.read()
    }
    // 블록 리스트 업데이트
    func update() {
        stars.forEach { star in
            refreshStore(star)
        }
    }
    // 휴식 시 스타의 블록 리스트를 비워줌
    func rest() {
        stars.forEach { star in
            clearStore(star)
        }
    }
    
    func startStar(_ star: Star) {
        let center = center(star)
        center.setShield(star)
    }
    
    func endStar(_ star: Star) {
        let center = center(star)
        center.clearShield()
    }
    
    private func refreshStore(_ star: Star) {
        let stateStyle = star.state().style
        
        if stateStyle == .ongoing {
            startStar(star)
        } else {
            endStar(star)
        }
    }
    
    private func clearStore(_ star: Star) {
        center(star).clearShield()
    }
    
    private func center(_ star: Star) -> ManagedSettingsStore {
        let storeName = ManagedSettingsStore.Name(from: star)
        let center = ManagedSettingsStore(named: storeName)
        
        return center
    }
}

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
    
    private var stars: [Star] { StarManager.shared.read() }
    
    // 블록 리스트 업데이트
    func update() {
        stars.forEach { star in
            updateStore(star)
        }
    }
    // 휴식 시 스타의 블록 리스트를 비워줌
    func rest() {
        stars.forEach { star in
            center(star).clearShield()
        }
    }
    // star 의 블록 리스트 설정
    func startStar(_ star: Star) {
        let center = center(star)
        center.setShield(star)
    }
    // star 의 블록 리스트 삭제
    func endStar(_ star: Star) {
        let center = center(star)
        center.clearShield()
    }
    // star 의 상태를 통해 블록 리스트 업데이트
    func updateStore(_ star: Star) {
        guard StarBreakManager().breakEndTime(of: star) == nil else {
            endStar(star)
            return
        }
        
        let stateStyle = star.state().style
        
        if stateStyle == .ongoing {
            startStar(star)
        } else {
            endStar(star)
        }
    }
    // star 와 매칭되는 ManagedSettingsStore 를 반환
    private func center(_ star: Star) -> ManagedSettingsStore {
        let storeName = ManagedSettingsStore.Name(from: star)
        let center = ManagedSettingsStore(named: storeName)
        
        return center
    }
    
}


extension ManagedSettingsStoreManager {
    // 이전 버전의 앱 블록 리스트 업데이트
    func clearLegacy() {
        // 해당 코드가 실행된 적 있는지 확인
        guard !UserDefaults.standard.isFamilyControlsRefactored else { return }
        // 기존 블록 리스트 설정 삭제
        ManagedSettingsStore().clearShield()
        // 블록 리스트 업데이트
        update()
        
        UserDefaults.standard.isFamilyControlsRefactored = true
    }
}

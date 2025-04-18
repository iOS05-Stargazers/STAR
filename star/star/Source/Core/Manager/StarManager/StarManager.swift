//
//  StarManager.swift
//  star
//
//  Created by 0-jerry on 1/30/25.
//

import Foundation.NSUUID

final class StarManager {
    
    static let shared = StarManager()
    private init() {}
    
    private let userDefaultsManager = StarUserDefaultsManager.shared
    private let deviceActivityScheduleManager = DeviceActivityScheduleManager()
    private let managedSettingsStoreManager = ManagedSettingsStoreManager()

    func create(_ star: Star) {
        // 저장소에 star 생성
        userDefaultsManager.create(star)
        // star 를 스케줄에 등록
        deviceActivityScheduleManager.creatSchedule(star)
        // star 의 상태를 확인해 잠금 리스트 업데이트
        if star.state().style == .ongoing {
            managedSettingsStoreManager.startStar(star)
        }
    }
    
    func read() -> [Star] {
        userDefaultsManager.read()
    }
    
    func delete(_ star: Star) {
        // 저장소의 star 삭제
        userDefaultsManager.delete(star)
        // 등록되어있는 star Schedule 삭제
        deviceActivityScheduleManager.deleteSchedule(star)
        // star 블록 리스트 삭제
        managedSettingsStoreManager.endStar(star)
    }
    
    func update(_ star: Star) {
        // 저장소의 star 업데이트
        userDefaultsManager.update(star)
        // 등록된 star 의 스케줄 업데이트
        deviceActivityScheduleManager.updateSchedule(star)
        // star 의 상태를 통해 블록 리스트 업데이트
        if star.state().style == .ongoing {
            managedSettingsStoreManager.startStar(star)
        } else {
            managedSettingsStoreManager.endStar(star)
        }
    }
    
    func read(_ uuid: UUID) -> Star? {
        read().filter { $0.identifier == uuid }.first
    }
}

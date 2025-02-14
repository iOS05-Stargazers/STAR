//
//  YouTubeBlocker.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/26.
//

import Foundation
import ManagedSettings
import FamilyControls
import DeviceActivity

struct BlockManager {
        
    // 앱 차단 로직
    func block(star: Star, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // DeviceActivityCenter를 사용하여 모든 선택한 앱 토큰에 대한 액티비티 차단
        let deviceActivityCenter = DeviceActivityCenter()
        
        let startTime = star.schedule.startTime
        let endTime = star.schedule.endTime
        
        // 모니터 DeviceActivitySchedule 설정
        let blockSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: startTime.hour, minute: startTime.minute),
            intervalEnd: DateComponents(hour: endTime.hour, minute: endTime.minute),
            repeats: true
        )
 
        do {
            try deviceActivityCenter.startMonitoring(DeviceActivityName(star.identifier.uuidString),
                                                     during: blockSchedule)
        } catch {
            completion(.failure(error))
            return
        }
        completion(.success(()))
    }
    
    func activities() {
        print(DeviceActivityCenter().activities.map { $0.rawValue })
    }
    
    func refreshSchedule() {
        self.resetSchedule()

        StarManager.shared.read()
            .forEach {
                self.block(star: $0, completion: { _ in })
            }
    }
    
    private func resetSchedule() {
        let deviceActivityCenter = DeviceActivityCenter()
        deviceActivityCenter.stopMonitoring([])
    }
}

//
//  DeviceActivityCenter+Extension.swift
//  star
//
//  Created by 0-jerry on 4/9/25.
//

import Foundation
import DeviceActivity

extension DeviceActivityCenter {
    // star 모니터링 시작
    func startMonitoring(_ star: Star) {
        let name = DeviceActivityName(from: star)
        let schedule = DeviceActivitySchedule(from: star)
        setMonitoring(name, during: schedule)
    }
    // 휴식 스케줄 등록
    func rest(_ schedule: DeviceActivitySchedule) {
        setMonitoring(.rest, during: schedule)
    }
    // 휴식 스케줄 종료
    func endRest() {
        stopMonitoring([.rest])
    }
    
    private func setMonitoring(_ name: DeviceActivityName, during schedule: DeviceActivitySchedule) {
        do {
            try startMonitoring(name,
                                during: schedule)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

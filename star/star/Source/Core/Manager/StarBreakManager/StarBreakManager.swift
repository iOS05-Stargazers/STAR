//
//  StarBreakManager.swift
//  star
//
//  Created by 0-jerry on 4/10/25.
//

import Foundation

// Star 중단 관리자
struct StarBreakManager {
    
    private let container = UserDefaults.appGroups
    private let deviceActivityScheduleManager = DeviceActivityScheduleManager()
    private let managedSettingsStoreManager = ManagedSettingsStoreManager()
    private let notificationManager = NotificationManager()
    
    // Star 의 중단이 설정되어있고, 현재시간보다 이후인 경우 반환
    func breakEndTime(of star: Star) -> Date? {
        let key = key(star)
        
        guard let date = container.value(forKey: key) as? Date,
              date > .now else {
            removeBreak(of: star)
            return nil
        }
        
        return date
    }
    // Star 중단 기한 설정
    // Star 의 중단 기한을 설정하는 경우, 기존의 Star 로 등록된 스케줄과 알림을 삭제하고, 중단 기한에 해당하는 스케줄을 등록한다.
    func breakStar(of star: Star, for date: Date) {
        let key = key(star)
        container.set(date, forKey: key)
        // FIXME: - 스타 중단 테스트용 알림 코드 ( 삭제 예정 )
        NotificationManager().starBreakTest(of: star)
        // Star 중단에 대한 스케줄 모니터링 삭제
        deviceActivityScheduleManager.createBreak(of: star)
        
        // 알림 & 스케줄 중단, 블록 리스트 초기화
        notificationManager.cancelNotification(star: star)
        deviceActivityScheduleManager.deleteSchedule(star)
        managedSettingsStoreManager.updateStore(star)
    }
    // Star 중단 종료
    // DeviceActivityMonitorExtension.intervalDidEnd 또는 사용자가 Star 중단을 종료할 경우 호출
    // Star 중단이 종료된 경우, Star 의 스케줄과 알림을 등록하고, 앱 블록리스트를 현재 시간에 맞춰 업데이트 해준다.
    func breakEnd(of star: Star) {
        removeBreak(of: star)
        // Star 중단에 대한 스케줄 모니터링 삭제
        deviceActivityScheduleManager.deleteBreak(of: star)
        
        // 알림 & 스케줄 등록, 블록 리스트 업데이트
        notificationManager.scheduleNotificaions(star: star)
        deviceActivityScheduleManager.createSchedule(star)
        managedSettingsStoreManager.updateStore(star)
    }
    
    func deleteBreak(of star: Star) {
        removeBreak(of: star)
        deviceActivityScheduleManager.deleteBreak(of: star)
    }
    
    private func removeBreak(of star: Star) {
        let key = key(star)
        container.removeObject(forKey: key)
    }
    // Star 의 중단을 위한 key 문자열 반환
    private func key(_ star: Star) -> String {
        return StarBreakIDFormmater.key(of: star)
    }
    
}


//
//  StarBreakTest.swift
//  star
//
//  Created by 0-jerry on 4/11/25.
//

import UserNotifications

// FIXME: - 해당 파일의 코드는 테스트용으로 작성돼, 기능을 모두 구현된 뒤에는 삭제해주시기 바랍니다.

// FIXME: - Star 중단 테스트용 알림 코드
extension NotificationManager {
    
    func starBreakTest(of star: Star) {
        guard let breakTime = StarBreakManager().breakEndTime(of: star) else { return }
        let key = StarBreakIDFormmater.key(of: star)
        
        let dateComponents = Calendar.current.dateComponents(Calendar.Component.forRawDate, from: breakTime)
        // 조건(시간, 반복)
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "STAR"
        notificationContent.body = "\(star.title) 중단 종료"
        notificationContent.sound = .default
        
        // 요청
        let request = UNNotificationRequest(
            identifier: key,
            content: notificationContent,
            trigger: trigger
        )
        
        // 알림 등록
        UNUserNotificationCenter.current().add(request) { _ in }
    }
}

// FIXME: - Star 중단 테스트용 코드
extension StarBreakManager {
    
    func test() {
        var count: Double = 1
        StarManager.shared.read().forEach { star in
            let date: Date = .now.addingTimeInterval( 60 * count )
            breakStar(of: star, for: date)
            count += 1
        }
    }
}

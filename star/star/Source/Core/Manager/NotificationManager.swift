//
//  UNUserNotificationCenter+Extension.swift
//  star
//
//  Created by 서문가은 on 2/13/25.
//

import UserNotifications

enum NotificationType {
    
    case willStartSoon(star: Star)
    case didStart(star: Star)
    case didEnd(star: Star)
    
    var title: String {
        return "STAR"
    }
    
    var body: String {
        switch self {
        case .willStartSoon(let star):
            return "\(star.title) 스타가 5분 뒤에 시작됩니다."
        case .didStart(let star):
            return "\(star.title) 스타가 시작되었습니다."
        case .didEnd(let star):
            return "\(star.title) 스타가 종료되었습니다."
        }
    }
    
    var identifier: String {
        switch self {
        case .willStartSoon(let star):
            return "\(star.identifier.uuidString)_startBefore"
        case .didStart(let star):
            return "\(star.identifier.uuidString)_start"
        case .didEnd(let star):
            return "\(star.identifier.uuidString)_finish"
        }
    }
}

final class NotificationManager: NSObject {
    // 알림 권한 요청
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
        }
    }
    
    // 알림 생성 (일정 등록)
    func scheduleNotificaions(star: Star) {
        scheduleNotificationList(
            for: star,
            type: .willStartSoon(star: star),
            dates: calculateWillStartSoonTimes(star)
        )
        scheduleNotificationList(
            for: star,
            type: .didStart(star: star),
            dates: star.schedule.starTimeDateComponentsList()
        )
        scheduleNotificationList(
            for: star,
            type: .didEnd(star: star),
            dates: star.schedule.finishTimeDateComponentsList()
        )
    }
    
    // 알림 삭제 (예약 취소)
    func cancelNotification(star: Star) {
        let startBeforeId = NotificationType.willStartSoon(star: star).identifier
        let startId = NotificationType.didStart(star: star).identifier
        let finishId = NotificationType.didEnd(star: star).identifier
        
        // 예약된 알림 삭제
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [startBeforeId, startId, finishId])
    }
    
    // 알림 내용 생성
    private func buildNotificationContent(mode: NotificationType) -> UNMutableNotificationContent {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = mode.title
        notificationContent.body = mode.body
        notificationContent.sound = .default
        
        return notificationContent
    }
    
    // 알림 예약
    private func scheduleNotification(dateComponents: DateComponents, type: NotificationType, content: UNMutableNotificationContent) {
        // 조건(시간, 반복)
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        // 요청
        let request = UNNotificationRequest(
            identifier: type.identifier,
            content: content,
            trigger: trigger
        )
        
        // 알림 등록
        UNUserNotificationCenter.current().add(request) { _ in }
    }
    
    // 특정 타입의 알림을 여러 개 스케줄링 하는 헬퍼 메서드
    private func scheduleNotificationList(for star: Star, type: NotificationType, dates: [DateComponents]) {
        let content = buildNotificationContent(mode: type)
        
        dates.forEach {
            scheduleNotification(
                dateComponents: $0,
                type: type,
                content: content
            )
        }
    }
    
    // 5분 전 알림 시간 계산
    private func calculateWillStartSoonTimes(_ star: Star) -> [DateComponents] {
        let startTime = star.schedule.startTime

        let willStartSoonList: [DateComponents] = star.schedule.weekDays.map { WeekDay in
            let startDate = DateComponents(hour: startTime.hour,
                                           minute: startTime.minute,
                                           weekday: WeekDay.rawValue)
            
            let calender = Calendar.current
            if let newDate = calender.date(from: startDate)?.addingTimeInterval(-5 * 60) {
                let newComponenets = calender.dateComponents([.hour, .minute, .weekday], from: newDate)
                return newComponenets
            }
            
            return startDate
        }
        return willStartSoonList
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    // 앱 실행중일 때 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}

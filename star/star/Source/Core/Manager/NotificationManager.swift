//
//  UNUserNotificationCenter+Extension.swift
//  star
//
//  Created by 서문가은 on 2/13/25.
//

import UserNotifications

enum NotificationType {
    
    case didStart(star: Star)
    case didEnd(star: Star)
    
    var title: String {
        return "STAR"
    }
    
    var body: String {
        switch self {
        case .didStart(let star):
            return String(format: "push_notification.star_in_progress".localized, star.title)
        case .didEnd(let star):
            return String(format: "push_notification.star_completed".localized, star.title)
        }
    }
    
    var identifier: String {
        switch self {
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
        let startId = NotificationType.didStart(star: star).identifier
        let finishId = NotificationType.didEnd(star: star).identifier
        
        // 매일 반복
        if star.schedule.weekDays.count == 7 {
            UNUserNotificationCenter.current()
                .removePendingNotificationRequests(withIdentifiers: [
                    startId + String(0),
                    finishId + String(0)
                ])
        } else {
            // 예약된 알림 삭제
            star.schedule.weekDays.forEach {
                UNUserNotificationCenter.current()
                    .removePendingNotificationRequests(withIdentifiers: [
                        startId + String($0.rawValue),
                        finishId + String($0.rawValue)
                    ])
            }
        }
    }
    
    // 특정 타입의 알림을 스케줄링 하는 메서드
    private func scheduleNotificationList(for star: Star, type: NotificationType, dates: [DateComponents]) {
        let content = buildNotificationContent(mode: type)
        
        // 매일 반복
        if dates.count == 7, let date = dates.first {
            var dateComponents = DateComponents()
            dateComponents.hour = date.hour
            dateComponents.minute = date.minute
            
            scheduleNotification(
                dateComponents: dateComponents,
                type: type,
                content: content
            )
        } else {
            // 특정 요일 반복
            dates.forEach {
                scheduleNotification(
                    dateComponents: $0,
                    type: type,
                    content: content
                )
            }
        }
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
        let weekDay = dateComponents.weekday ?? 0 // 일주일 반복이면 0
        let request = UNNotificationRequest(
            identifier: type.identifier + String(weekDay),
            content: content,
            trigger: trigger
        )
        
        // 알림 등록
        UNUserNotificationCenter.current().add(request) { _ in }
    }
    
    // 휴식 종료 알림 예약
    func restEndNotification() {
        guard let restEndTime = RestManager().restEndTimeGet() else { return }
        let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second, .nanosecond], from: restEndTime)
        // 조건(시간, 반복)
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "STAR"
        notificationContent.body = "push_notification.break_ended".localized
        notificationContent.sound = .default
        
        // 요청
        let request = UNNotificationRequest(
            identifier: "restEnd",
            content: notificationContent,
            trigger: trigger
        )
        
        // 알림 등록
        UNUserNotificationCenter.current().add(request) { _ in }
    }
    
    func removeRest() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["restEnd"])
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    // 앱 실행중일 때 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}

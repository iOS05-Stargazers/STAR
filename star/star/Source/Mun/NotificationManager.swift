//
//  UNUserNotificationCenter+Extension.swift
//  star
//
//  Created by 서문가은 on 2/13/25.
//

import Foundation
import UserNotifications

enum NotificationType {
    case startTime(star: Star)
    case finishTime(star: Star)
    
    var title: String {
        switch self {
        case .startTime:
            return "스타 시작 알림"
        case .finishTime:
            return "스타 종료 알림"
        }
    }
    
    var body: String {
        switch self {
        case .startTime(let star):
            return "\(star.title) 스타가 시작되었습니다."
        case .finishTime(let star):
            return "\(star.title) 스타가 종료되었습니다."
        }
    }
    
    var identifier: String {
        switch self {
        case .startTime(let star):
            return "\(star.identifier.uuidString)_start"
        case .finishTime(let star):
            return "\(star.identifier.uuidString)_finish"
        }
    }
}

struct NotificationManager {

    // 알림 생성 (일정 등록)
    func scheduleNotificaions(star: Star) {
        let startMode = NotificationType.startTime(star: star)
        let finishMode = NotificationType.finishTime(star: star)
        
        let startTimeContent = buildNotificationContent(mode: startMode)
        let finishTimeContent = buildNotificationContent(mode: finishMode)
        
        let startTimes = star.schedule.starTimeDateComponentsList()
        let finishTimes = star.schedule.finishTimeDateComponentsList()
        
        startTimes.forEach {
            scheduleNotification(
                dateComponents: $0,
                mode: startMode,
                content: startTimeContent
            )
        }
        
        finishTimes.forEach {
            scheduleNotification(
                dateComponents: $0,
                mode: finishMode,
                content: finishTimeContent
            )
        }
    }
    
    // 알림 삭제 (예약 취소)
    func cancelNotification(star: Star) {
        let startId = NotificationType.startTime(star: star).identifier
        let finishId = NotificationType.finishTime(star: star).identifier
        
        // 전달된 알림 삭제
        UNUserNotificationCenter.current()
            .removeDeliveredNotifications(withIdentifiers: [startId, finishId])
        
        // 예약된 알림 삭제
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [startId, finishId])
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
    private func scheduleNotification(dateComponents: DateComponents, mode: NotificationType, content: UNMutableNotificationContent) {
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: mode.identifier,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}

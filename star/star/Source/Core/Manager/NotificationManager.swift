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
    case endTime(star: Star)
    
    var title: String {
        switch self {
        case .startTime:
            return "스타 시작 알림"
        case .endTime:
            return "스타 종료 알림"
        }
    }
    
    var body: String {
        switch self {
        case .startTime(let star):
            return "\(star.title) 스타가 시작되었습니다."
        case .endTime(let star):
            return "\(star.title) 스타가 종료되었습니다."
        }
    }
    
    var identifier: String {
        switch self {
        case .startTime(let star):
            return "\(star.identifier.uuidString)_start"
        case .endTime(let star):
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
        let startType = NotificationType.startTime(star: star)
        let endType = NotificationType.endTime(star: star)
        
        let startTimeContent = buildNotificationContent(mode: startType)
        let endTimeContent = buildNotificationContent(mode: endType)
        
        let startTimes = star.schedule.starTimeDateComponentsList()
        let endTimes = star.schedule.finishTimeDateComponentsList()
        
        startTimes.forEach {
            scheduleNotification(
                dateComponents: $0,
                type: startType,
                content: startTimeContent
            )
        }
        
        endTimes.forEach {
            scheduleNotification(
                dateComponents: $0,
                type: endType,
                content: endTimeContent
            )
        }
    }
    
    // 알림 삭제 (예약 취소)
    func cancelNotification(star: Star) {
        let startId = NotificationType.startTime(star: star).identifier
        let finishId = NotificationType.endTime(star: star).identifier
        
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
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    // 앱 실행중일 때 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}

//
//  UNUserNotificationCenter+Extension.swift
//  star
//
//  Created by 서문가은 on 2/13/25.
//

import Foundation
import UserNotifications

class LocalNotificationHelper {

    func pushNotification(title: String, body: String, seconds: Double, identifier: String) {
        
        // 1️⃣ 알림 내용, 설정
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        
        // 2️⃣ 조건(시간, 반복)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
//        let componenet = Calendar.current.dateComponents([.hour, .minute], from: date)
//        print(date, componenet)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: componenet, repeats: false)
        
        // 3️⃣ 요청
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        
        // 4️⃣ 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func delete() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

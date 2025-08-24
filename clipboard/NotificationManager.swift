//
//  NotificationManager.swift
//  MyFirstMacApp
//
//  Created by Cat on 2025/8/24.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    
    static let instance = NotificationManager() // Singleton
    
    // 请求授权
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification(title: String, subtitle: String? = nil, body: String, timeInterval: TimeInterval, repeats: Bool = false) {
        // 创建通知内容
        let content = UNMutableNotificationContent()
        content.title = title
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        content.body = body
        content.sound = .default
        
        // 创建触发器
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        
        // 创建请求
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        // 将请求添加到通知中心
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("添加通知失败: \(error.localizedDescription)")
            } else {
                print("成功添加通知! 标题: '\(title)'")
            }
        }
    }
}

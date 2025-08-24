//
//  MyFirstMacAppApp.swift
//  MyFirstMacApp
//
//  Created by Cat on 2025/8/24.
//

import SwiftUI
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

@main
struct clipboardApp: App {
    @AppStorage("clipboardMaxLength") var clipboardMaxLength: Int = 20
    @Environment(\.openWindow) var openWindow
    // 创建管理器
    @StateObject private var manager = ClipboardManager()
    
    private let notificationDelegate = NotificationDelegate()
    init() {
        // 设置通知中心的 delegate
        UNUserNotificationCenter.current().delegate = notificationDelegate
        
        // 启动时请求用户授权
        NotificationManager.instance.requestAuthorization()
    }
    
    var body: some Scene {
        MenuBarExtra {
            // 显示管理器里的历史记录
            ForEach(manager.history, id: \.self) { item in
                if item.count > clipboardMaxLength {
                    let LongString = item.prefix(clipboardMaxLength)
                    Button(LongString){
                        print(item)
                        copyToClipboard(text: item)
                        NotificationManager.instance.scheduleNotification(
                            title: "复制成功！",
                            body: item,
                            timeInterval: 0.1
                        )
                    }
                }
                else {
                    Button(item){
                        print(item)
                        copyToClipboard(text: item)
                        NotificationManager.instance.scheduleNotification(
                            title: "复制成功！",
                            body: item,
                            timeInterval: 0.1
                        )
                    }
                }
            }
                
            // 分隔线
            Divider()
                
            
            // 设置/退出按钮
            Button("设置") {
                //openWindow(id: "settings")
                openWindow(id: "settings", value: "main-settings")
            }
            Button("退出") {
                exit(0)
            }
        } label: {
            // 在菜单栏上显示的图标
            Image(systemName: "clipboard")
        }
        
        //WindowGroup(id: "settings") {
        //    ContentView()
        //}.windowResizability(.contentSize)
        
        WindowGroup(id: "settings", for: String.self) { $value in
            ContentView()
        }.windowResizability(.contentSize)
    }
    private func copyToClipboard(text: String) {
            // 获取系统的通用剪贴板
            let pasteboard = NSPasteboard.general
            
            // 在写入前清空剪贴板
            pasteboard.clearContents()
            
            // 将字符串写入剪贴板
            pasteboard.setString(text, forType: .string)
            
        }
}


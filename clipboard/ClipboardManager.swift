//
//  ClipboardManager.swift
//  MyFirstMacApp
//
//  Created by Cat on 2025/8/24.
//
import SwiftUI

class ClipboardManager: ObservableObject {
    @AppStorage("clipboardMaxNum") var clipboardMaxNum: Int = 10
    // 当 history 数组变化时，刷新界面
    @Published var history: [String] = []
    
    private var pasteboard = NSPasteboard.general
    private var timer: Timer?
    private var lastChangeCount = 0

    init() {
        // 每隔1秒钟，就调用一次 checkForChanges 函数
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkForChanges()
        }
    }

    func checkForChanges() {
        // 检查内容与历史记录是否一致
        if pasteboard.changeCount != lastChangeCount {
            
            // 尝试读取文字
            if let newText = pasteboard.string(forType: .string) {
                
                if self.history.first != newText {
                    self.history.removeAll(where: { $0 == newText })
                    // 把新内容插入到数组的最前面
                    self.history.insert(newText, at: 0)
                    if self.history.count > clipboardMaxNum {
                        self.history.removeLast()
                    }
                }
            }
            
            // 更新变化计数器
            lastChangeCount = pasteboard.changeCount
        }
    }
}

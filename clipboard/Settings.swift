//
//  ContentView.swift
//  MyFirstMacApp
//
//  Created by Cat on 2025/8/24.
//

import SwiftUI
import ServiceManagement

class LaunchAtLoginManager: ObservableObject {
    @Published var isEnabled: Bool = false
    
    init() {
        checkStatus()
    }
    
    func toggle() {
        if isEnabled {
            disable()
        } else {
            enable()
        }
    }
    
    private func enable() {
        do {
            if #available(macOS 13.0, *) {
                try SMAppService.mainApp.register()
                isEnabled = true
            } else {
                let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.yourcompany.yourapp"
                let success = SMLoginItemSetEnabled(bundleIdentifier as CFString, true)
                isEnabled = success
            }
        } catch {
            print("启用开机启动失败: \(error)")
        }
    }
    
    private func disable() {
        do {
            if #available(macOS 13.0, *) {
                try SMAppService.mainApp.unregister()
                isEnabled = false
            } else {
                let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.yourcompany.yourapp"
                let success = SMLoginItemSetEnabled(bundleIdentifier as CFString, false)
                isEnabled = !success
            }
        } catch {
            print("禁用开机启动失败: \(error)")
        }
    }
    
    private func checkStatus() {
        if #available(macOS 13.0, *) {
            isEnabled = SMAppService.mainApp.status == .enabled
        } else {
            isEnabled = false
        }
    }
}

struct ContentView: View {
    @StateObject private var launchManager = LaunchAtLoginManager()
    
    @AppStorage("clipboardMaxLength") var clipboardMaxLength: Int = 20
    @AppStorage("clipboardMaxNum") var clipboardMaxNum: Int = 10
    
    private var maxLengthBinding: Binding<String> {
        Binding<String>(
            get: {
                return String(self.clipboardMaxLength)
            },
            set: {
                if let value = Int($0) {
                    self.clipboardMaxLength = value
                }
            }
        )
    }
    private var maxNumBinding: Binding<String> {
        Binding<String>(
            get: {
                return String(self.clipboardMaxNum)
            },
            set: {
                if let value = Int($0) {
                    self.clipboardMaxNum = value
                }
            }
        )
    }
    
    var body: some View {
        VStack(spacing: 15) {
            
            HStack(){
                Text("剪切板最大长度:").navigationTitle("历史剪切板")
                TextField("\(maxLengthBinding)", text: maxLengthBinding)
                    .frame(width: 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.trailing)
            }
            
            HStack(){
                Text("剪切板最大数量:")
                TextField("\(maxNumBinding)", text: maxNumBinding)
                    .frame(width: 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.trailing)
            }
            
            Toggle("开机启动", isOn: Binding(
                get: { launchManager.isEnabled },
                set: { _ in launchManager.toggle() }
            ))
            .toggleStyle(.switch)
        }
        .windowMinimizeBehavior(.disabled)
        .windowFullScreenBehavior(.disabled)
        .windowResizeBehavior(.disabled)
        .padding()
        .frame(width: 300, height: 150)
    }
}

#Preview {
    ContentView()
}

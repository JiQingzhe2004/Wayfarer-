//
//  WayfarerApp.swift
//  Wayfarer+
//
//  Created by Trae AI on 2025/5/10.
//

import SwiftUI

@main
struct WayfarerApp: App {
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(colorSchemeManager.selectedAppearance.colorScheme)
                .onAppear {
                    // 应用启动时更新颜色模式
                    colorSchemeManager.updateColorScheme()
                }
        }
    }
}
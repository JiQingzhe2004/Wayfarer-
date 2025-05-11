//
//  Colors.swift
//  Wayfarer+
//
//  Created by Trae AI on 2025/5/10.
//

import SwiftUI

struct AppColors {
    // 主色
    static var primary: Color {
        ColorSchemeManager.shared.colorScheme == .dark ? Color(hex: "0A84FF") : Color(hex: "007AFF")
    }
    
    // 辅助色
    static var background: Color {
        ColorSchemeManager.shared.colorScheme == .dark ? Color(hex: "1C1C1E") : Color.white
    }
    static var secondaryBackground: Color {
        ColorSchemeManager.shared.colorScheme == .dark ? Color(hex: "2C2C2E") : Color(hex: "F2F2F7")
    }
    static var text: Color {
        ColorSchemeManager.shared.colorScheme == .dark ? Color.white : Color.black
    }
    static var secondaryText: Color {
        ColorSchemeManager.shared.colorScheme == .dark ? Color(hex: "EBEBF5").opacity(0.6) : Color(hex: "8E8E93")
    }
    static var accent: Color {
        ColorSchemeManager.shared.colorScheme == .dark ? Color(hex: "FF9F0A") : Color(hex: "FF9500")
    }
}

// 扩展Color以支持十六进制颜色初始化
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
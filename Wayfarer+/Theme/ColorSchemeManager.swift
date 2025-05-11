//
//  ColorSchemeManager.swift
//  Wayfarer+
//
//  Created by Trae AI on 2025/5/10.
//

import SwiftUI
import Combine

enum AppColorScheme: String, CaseIterable, Identifiable {
    case light = "浅色"
    case dark = "深色"
    case system = "跟随系统"
    
    var id: String { self.rawValue }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

class ColorSchemeManager: ObservableObject {
    static let shared = ColorSchemeManager()
    
    @Published var selectedAppearance: AppColorScheme = .system {
        didSet {
            UserDefaults.standard.set(selectedAppearance.rawValue, forKey: "appAppearance")
            updateColorScheme()
        }
    }
    
    @Published var colorScheme: ColorScheme = .light
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // 从UserDefaults加载保存的外观设置
        if let savedAppearance = UserDefaults.standard.string(forKey: "appAppearance"),
           let appearance = AppColorScheme.allCases.first(where: { $0.rawValue == savedAppearance }) {
            selectedAppearance = appearance
        }
        
        // 监听系统外观变化
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.updateColorScheme()
            }
            .store(in: &cancellables)
        
        updateColorScheme()
    }
    
    func updateColorScheme() {
        switch selectedAppearance {
        case .light:
            colorScheme = .light
        case .dark:
            colorScheme = .dark
        case .system:
            colorScheme = UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
        }
    }
}
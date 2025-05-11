//
//  MainTabView.swift
//  Wayfarer+
//
//  Created by Trae AI on 2025/5/10.
//

import SwiftUI

// Import components from the Components directory

struct MainTabView: View {
    @State private var selectedTab = 0
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("首页")
                }
                .tag(0)
            
            MyTravelView()
                .tabItem {
                    Image(systemName: "map")
                    Text("我的旅游")
                }
                .tag(1)
            
            PublishGuideView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("发布")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("个人中心")
                }
                .tag(3)
        }
        .accentColor(AppColors.primary)
        .preferredColorScheme(colorSchemeManager.selectedAppearance.colorScheme)
        .background(AppColors.background.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    MainTabView()
}
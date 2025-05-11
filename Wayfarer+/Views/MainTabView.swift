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
    }
}

// 临时视图占位符
// struct HomeView: View {
//     var body: some View {
//         NavigationView {
//             ScrollView {
//                 VStack(spacing: 16) {
//                     // 搜索栏
//                     HStack {
//                         Image(systemName: "magnifyingglass")
//                             .foregroundColor(.gray)
//                         Text("搜索目的地、攻略")
//                             .foregroundColor(.gray)
//                         Spacer()
//                     }
//                     .padding()
//                     .background(Color(.systemGray6))
//                     .cornerRadius(8)
//                     .padding(.horizontal)
//                     // 分类导航
//                     ScrollView(.horizontal, showsIndicators: false) {
//                         HStack(spacing: 20) {
//                             CategoryTab(title: "热门", isSelected: true)
//                             CategoryTab(title: "城市", isSelected: false)
//                             CategoryTab(title: "美食", isSelected: false)
//                             CategoryTab(title: "自驾", isSelected: false)
//                             CategoryTab(title: "文化", isSelected: false)
//                         }
//                         .padding(.horizontal)
//                     }
//                     // 攻略卡片
//                     ForEach(1...5, id: \.self) { _ in
//                         GuideCard()
//                     }
//                 }
//             }
//             .navigationTitle("发现攻略")
//         }
//     }
// }

// 这些视图已在各自的文件中定义，不需要在这里重复定义

// 这些组件已在 Components/GuideCard.swift 中定义

#Preview {
    MainTabView()
}
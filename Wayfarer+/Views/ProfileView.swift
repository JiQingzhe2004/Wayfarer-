//
//  ProfileView.swift
//  Wayfarer+
//
//  Created by Trae AI on 2025/5/10.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedTab = 0
    @State private var showSettings = false
    @State private var topSafeAreaHeight: CGFloat = 0
    let tabs = ["我的攻略", "收藏", "旅行记录"]
    
    // 模拟用户数据
    let username = "旅行达人"
    let bio = "热爱旅行，分享世界各地的美景和文化"
    let publishedGuides = 12
    let completedTravels = 25
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // 顶部用户信息区域
                    profileHeaderView
                    
                    // 标签切换
                    tabSelectionView
                    
                    // 内容区域
                    contentView
                }
            }
            .background(AppColors.background.edgesIgnoringSafeArea(.all))
            .edgesIgnoringSafeArea(.top)
            .navigationBarItems(
                trailing: Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gearshape")
                        .foregroundColor(AppColors.primary)
                }
            )
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    // 顶部个人资料视图
    private var profileHeaderView: some View {
        ZStack(alignment: .top) {
            // 背景渐变
            LinearGradient(
                gradient: Gradient(colors: [AppColors.primary, ColorSchemeManager.shared.colorScheme == .dark ? Color(hex: "1C1C1E") : .white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)
            .overlay(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            // 获取顶部安全区域高度
                            self.topSafeAreaHeight = geometry.safeAreaInsets.top
                        }
                }
            )
            
            VStack(spacing: 16) {
                Spacer()
                    .frame(height: topSafeAreaHeight + 20) // 为顶部安全区域预留空间
                
                // 头像和用户信息并排布局
                HStack(alignment: .center, spacing: 20) {
                    // 头像
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    
                    // 用户名和简介
                    VStack(alignment: .leading, spacing: 4) {
                        Text(username)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(bio)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal, 20)
                
                // 统计信息
                HStack(spacing: 30) {
                    VStack {
                        Text("\(publishedGuides)")
                            .font(.headline)
                        Text("发布的攻略")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text("\(completedTravels)")
                            .font(.headline)
                        Text("完成的旅行")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(AppColors.background)
                .cornerRadius(12)
                .shadow(color: ColorSchemeManager.shared.colorScheme == .dark ? Color.black.opacity(0.2) : Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 16)
        }
        .frame(height: 280) // 固定顶部信息区域高度
    }
    
    // 标签选择视图
    var tabSelectionView: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(tabs[index])
                            .font(.subheadline)
                            .fontWeight(selectedTab == index ? .semibold : .regular)
                            .foregroundColor(selectedTab == index ? AppColors.primary : .gray)
                        
                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(selectedTab == index ? AppColors.primary : .clear)
                            .cornerRadius(1.5)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 12)
        .background(AppColors.background)
    }
    
    // 内容区域视图
    var contentView: some View {
        GeometryReader { geometry in
            TabView(selection: $selectedTab) {
                // 我的攻略
                contentSection(count: 3) { _ in
                    GuideCard()
                }
                .tag(0)
                
                // 收藏
                contentSection(count: 2) { _ in
                    GuideCard()
                }
                .tag(1)
                
                // 旅行记录
                contentSection(count: 4) { _ in
                    TravelRecordCard()
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            // 动态计算内容区域高度，确保在各种设备上都能正确显示
            .frame(height: geometry.size.height)
            .animation(.easeInOut, value: selectedTab)
        }
        // 设置最小高度，确保有足够的空间显示内容
        .frame(minHeight: UIScreen.main.bounds.height * 0.5)
    }
    
    // 内容区域通用构建方法
    func contentSection<T: View>(count: Int, content: @escaping (Int) -> T) -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(1...count, id: \.self) { index in
                    content(index)
                }
            }
            .padding()
        }
        .background(AppColors.background)
    }
}

// 旅行记录卡片
struct TravelRecordCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 封面图
            ZStack(alignment: .topTrailing) {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 160)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(12)
                    .clipped()
                
                // 完成标签
                Text("已完成")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    .padding(12)
            }
            
            // 信息
            VStack(alignment: .leading, spacing: 10) {
                Text("巴黎三日游")
                    .font(.headline)
                    .fontWeight(.bold)
                
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.subheadline)
                        .foregroundColor(AppColors.primary.opacity(0.8))
                    Text("2025年4月10日 - 2025年4月13日")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundColor(AppColors.primary.opacity(0.8))
                    Text("巴黎, 法国")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // 添加互动按钮
                HStack {
                    Button(action: {}) {
                        Label("分享", systemImage: "square.and.arrow.up")
                            .font(.caption)
                            .foregroundColor(AppColors.primary)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Label("查看详情", systemImage: "chevron.right")
                            .font(.caption)
                            .foregroundColor(AppColors.primary)
                    }
                }
                .padding(.top, 5)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(AppColors.background)
        .cornerRadius(12)
        .shadow(color: ColorSchemeManager.shared.colorScheme == .dark ? Color.black.opacity(0.2) : Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 2)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

//
//  ProfileView.swift
//  Wayfarer+
//
//  Created by Trae AI on 2025/5/10.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedTab = 0
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
                    // 顶部用户信息
                    ZStack(alignment: .top) {
                        // 背景渐变
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.primary, .white]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 150)
                        
                        VStack(spacing: 16) {
                            // 头像
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .padding(.top, 20)
                            
                            // 用户名和简介
                            VStack(spacing: 4) {
                                Text(username)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(bio)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
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
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                        }
                        .padding(.bottom, 16)
                    }
                    
                    // 内容标签页
                    VStack(spacing: 0) {
                        // 标签切换
                        HStack {
                            ForEach(0..<tabs.count, id: \.self) { index in
                                Button(action: {
                                    selectedTab = index
                                }) {
                                    VStack(spacing: 8) {
                                        Text(tabs[index])
                                            .font(.subheadline)
                                            .foregroundColor(selectedTab == index ? AppColors.primary : .gray)
                                        
                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundColor(selectedTab == index ? AppColors.primary : .clear)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        // 内容区域
                        TabView(selection: $selectedTab) {
                            // 我的攻略
                            LazyVStack(spacing: 16) {
                                ForEach(1...3, id: \.self) { _ in
                                    GuideCard()
                                }
                            }
                            .padding()
                            .tag(0)
                            
                            // 收藏
                            LazyVStack(spacing: 16) {
                                ForEach(1...2, id: \.self) { _ in
                                    GuideCard()
                                }
                            }
                            .padding()
                            .tag(1)
                            
                            // 旅行记录
                            LazyVStack(spacing: 16) {
                                ForEach(1...4, id: \.self) { _ in
                                    TravelRecordCard()
                                }
                            }
                            .padding()
                            .tag(2)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: UIScreen.main.bounds.height * 0.6)
                    }
                    
                    // 设置按钮
                    Button(action: {
                        // 跳转到设置页面
                    }) {
                        Text("设置")
                            .font(.headline)
                            .foregroundColor(AppColors.primary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(AppColors.primary, lineWidth: 1)
                            )
                    }
                    .padding()
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }
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
                    .frame(height: 150)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                
                // 完成标签
                Text("已完成")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .padding(8)
            }
            
            // 信息
            VStack(alignment: .leading, spacing: 8) {
                Text("巴黎三日游")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("2025年4月10日 - 2025年4月13日")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)
                    Text("巴黎, 法国")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
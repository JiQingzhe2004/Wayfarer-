//
//  MyTravelView.swift
//  Wayfarer+
//
//  Created by Trae AI on 2025/5/10.
//

import SwiftUI

struct MyTravelView: View {
    @State private var selectedTab = 0
    let tabs = ["未开始", "进行中", "已完成"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 设置背景色
                Color.clear.background(AppColors.background).edgesIgnoringSafeArea(.all)
                // 顶部标签切换
                HStack(spacing: 0) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Button(action: {
                            selectedTab = index
                        }) {
                            Text(tabs[index])
                                .font(.headline)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(selectedTab == index ? AppColors.primary : AppColors.background)
                                .foregroundColor(selectedTab == index ? .white : AppColors.secondaryText)
                        }
                    }
                }
                .background(AppColors.background)
                .cornerRadius(8)
                .padding()
                .shadow(color: ColorSchemeManager.shared.colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                // 旅行列表
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(1...5, id: \.self) { index in
                            TravelCard(status: getStatus())
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("我的旅游")
            .navigationBarTitleDisplayMode(.inline)
            .background(AppColors.background.edgesIgnoringSafeArea(.all))
        }
    }
    
    private func getStatus() -> String {
        switch selectedTab {
        case 0:
            return "未开始"
        case 1:
            return "进行中"
        case 2:
            return "已完成"
        default:
            return "未开始"
        }
    }
}

// 旅行卡片组件
struct TravelCard: View {
    let status: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // 封面图
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(8)
            
            // 信息
            VStack(alignment: .leading, spacing: 8) {
                Text("巴黎三日游攻略")
                    .font(.headline)
                    .lineLimit(1)
                
                Text("巴黎")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    // 状态标签
                    Text(status)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor(status))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    // 操作按钮
                    Button(action: {
                        // 开始或完成旅行
                    }) {
                        Text(status == "未开始" ? "开始旅行" : (status == "进行中" ? "旅行完成" : ""))
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(status == "已完成" ? Color.clear : AppColors.accent)
                            .foregroundColor(status == "已完成" ? .clear : .white)
                            .cornerRadius(4)
                    }
                    .opacity(status == "已完成" ? 0 : 1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(AppColors.background)
        .cornerRadius(12)
        .shadow(color: ColorSchemeManager.shared.colorScheme == .dark ? Color.black.opacity(0.2) : Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status {
        case "未开始":
            return Color.gray
        case "进行中":
            return AppColors.primary
        case "已完成":
            return Color.green // 绿色
        default:
            return Color.gray
        }
    }
}

#Preview {
    MyTravelView()
}
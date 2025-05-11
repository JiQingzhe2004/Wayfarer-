//
//  GuideCard.swift
//  Wayfarer+
//
//  Created by Trae AI on 2025/5/10.
//

import SwiftUI

// 攻略卡片组件 - 在首页和个人中心页面共用
struct GuideCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 封面图
            ZStack(alignment: .bottomLeading) {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
            }
            // 标题
            Text("巴黎三日游攻略")
                .font(.headline)
                .foregroundColor(AppColors.text)
                .lineLimit(1)
            // 底部信息
            HStack {
                Text("旅行达人")
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                Spacer()
                Text("1234人使用")
                    .font(.subheadline)
                    .foregroundColor(AppColors.primary)
                Text("巴黎")
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.horizontal)
        .background(AppColors.background)
        .cornerRadius(12)
        .shadow(color: ColorSchemeManager.shared.colorScheme == .dark ? Color.black.opacity(0.2) : Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}

// 分类标签组件 - 在首页使用
struct CategoryTab: View {
    let title: String
    let isSelected: Bool
    var body: some View {
        Text(title)
            .fontWeight(isSelected ? .bold : .regular)
            .foregroundColor(isSelected ? AppColors.primary : AppColors.secondaryText)
            .padding(.bottom, 5)
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(isSelected ? AppColors.primary : .clear),
                alignment: .bottom
            )
    }
}

struct GuideCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GuideCard()
            HStack {
                CategoryTab(title: "热门", isSelected: true)
                CategoryTab(title: "城市", isSelected: false)
            }
        }
        .padding()
    }
}
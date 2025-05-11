//
//  HomeView.swift
//  Wayfarer+
//
//  Created by Trae AI on 2025/5/10.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "热门"
    @State private var showingFilter = false
    
    let categories = ["热门", "城市", "美食", "自驾", "文化"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 搜索栏
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("搜索目的地、攻略", text: $searchText)
                            .foregroundColor(.primary)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    Button(action: {
                        showingFilter.toggle()
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(AppColors.primary)
                    }
                }
                .padding()
                
                // 分类导航
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(categories, id: \.self) { category in
                            CategoryTab(title: category, isSelected: selectedCategory == category)
                                .onTapGesture {
                                    selectedCategory = category
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
                
                // 攻略列表
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(1...10, id: \.self) { index in
                            NavigationLink(destination: GuideDetailView()) {
                                GuideCard()
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("发现攻略")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingFilter) {
                FilterView()
            }
        }
    }
}

// 筛选视图
struct FilterView: View {
    @State private var selectedCities: [String] = []
    @State private var selectedTags: [String] = []
    
    let cities = ["北京", "上海", "广州", "深圳", "成都", "杭州", "巴黎", "东京", "纽约"]
    let tags = ["美食", "文化", "自然", "历史", "购物", "自驾", "徒步", "摄影"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("城市")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(cities, id: \.self) { city in
                                FilterChip(title: city, isSelected: selectedCities.contains(city)) {
                                    if selectedCities.contains(city) {
                                        selectedCities.removeAll { $0 == city }
                                    } else {
                                        selectedCities.append(city)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Section(header: Text("标签")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(tags, id: \.self) { tag in
                                FilterChip(title: tag, isSelected: selectedTags.contains(tag)) {
                                    if selectedTags.contains(tag) {
                                        selectedTags.removeAll { $0 == tag }
                                    } else {
                                        selectedTags.append(tag)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Section {
                    Button(action: {
                        // 应用筛选
                    }) {
                        Text("应用筛选")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(AppColors.primary)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        selectedCities = []
                        selectedTags = []
                    }) {
                        Text("重置")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(AppColors.primary)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(AppColors.primary, lineWidth: 1)
                            )
                    }
                }
            }
            .navigationTitle("筛选")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// 筛选标签组件
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? AppColors.primary : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

// 攻略详情页面占位符
struct GuideDetailView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 封面图
                ZStack(alignment: .bottom) {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .background(Color.gray.opacity(0.3))
                        .clipped()
                    
                    // 标题和作者
                    VStack(alignment: .leading, spacing: 4) {
                        Text("巴黎三日游攻略")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("旅行达人")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                
                // 正文内容
                VStack(alignment: .leading, spacing: 16) {
                    Text("攻略内容")
                        .font(.headline)
                    
                    Text("这是一份详细的巴黎三日游攻略，包含了卢浮宫、埃菲尔铁塔、凯旋门等著名景点的参观建议，以及当地美食推荐和交通指南。")
                        .font(.body)
                    
                    // 地图
                    ZStack {
                        Color.gray.opacity(0.3)
                        Text("地图区域")
                    }
                    .frame(height: 200)
                    .cornerRadius(8)
                    
                    // 景点列表
                    VStack(alignment: .leading, spacing: 12) {
                        Text("景点列表")
                            .font(.headline)
                        
                        ForEach(1...3, id: \.self) { index in
                            HStack {
                                Text("景点 \(index)")
                                    .font(.subheadline)
                                Spacer()
                                Button("导航") {
                                    // 导航操作
                                }
                                .font(.subheadline)
                                .foregroundColor(AppColors.primary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        // 使用该方案
                    }) {
                        Text("使用该方案")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: 44)
                            .background(AppColors.accent)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "heart")
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "bubble.left")
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "star")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Text("1234人使用")
                        .font(.subheadline)
                        .foregroundColor(AppColors.primary)
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 2)
            }
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
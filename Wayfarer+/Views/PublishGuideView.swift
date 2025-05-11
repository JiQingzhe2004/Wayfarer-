//
//  PublishGuideView.swift
//  Wayfarer+
//
//  Created by Trae AI on 2025/5/10.
//

import SwiftUI

struct PublishGuideView: View {
    @State private var title = ""
    @State private var content = ""
    @State private var city = ""
    @State private var selectedTags: [String] = []
    @State private var showingImagePicker = false
    @State private var showingPreview = false
    @State private var showingMapSearch = false
    @State private var images: [UIImage] = []
    
    let tags = ["美食", "文化", "自然", "历史", "购物", "自驾", "徒步", "摄影"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("攻略标题", text: $title)
                        .font(.headline)
                    
                    TextField("目的地城市", text: $city)
                }
                
                Section(header: Text("封面图片")) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text(images.isEmpty ? "添加图片" : "已选择\(images.count)张图片")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if !images.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(0..<min(images.count, 5), id: \.self) { index in
                                    Image(uiImage: images[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                
                                if images.count > 5 {
                                    Text("+\(images.count - 5)")
                                        .frame(width: 80, height: 80)
                                        .background(Color.gray.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                
                Section(header: Text("攻略内容")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                        .overlay(
                            Text(content.isEmpty ? "描述你的旅行体验、推荐景点和实用建议..." : "")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8),
                            alignment: .topLeading
                        )
                }
                
                Section(header: Text("标签")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(tags, id: \.self) { tag in
                                TagButton(title: tag, isSelected: selectedTags.contains(tag)) {
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
                
                Section(header: Text("地图标记")) {
                    Button(action: {
                        showingMapSearch = true
                    }) {
                        HStack {
                            Image(systemName: "map")
                            Text("添加景点位置")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 地图预览占位
                    ZStack {
                        Color.gray.opacity(0.2)
                        Text("地图预览")
                    }
                    .frame(height: 150)
                    .cornerRadius(8)
                }
                
                Section {
                    Button(action: {
                        // 预览攻略
                        showingPreview = true
                    }) {
                        Text("预览")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(AppColors.primary)
                    }
                    
                    Button(action: {
                        // 提交攻略
                        submitGuide()
                    }) {
                        Text("提交")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(isFormValid ? AppColors.accent : Color.gray)
                            .cornerRadius(8)
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("发布攻略")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("取消") {
                    // 取消操作
                },
                trailing: EmptyView()
            )
            .sheet(isPresented: $showingImagePicker) {
                Text("图片选择器")
            }
            .sheet(isPresented: $showingMapSearch) {
                Text("地图搜索")
            }
            .sheet(isPresented: $showingPreview) {
                GuidePreviewView(title: title, content: content, city: city, tags: selectedTags)
            }
        }
    }
    
    private var isFormValid: Bool {
        !title.isEmpty && !content.isEmpty && !city.isEmpty
    }
    
    private func submitGuide() {
        // 提交攻略到服务器
        print("提交攻略: \(title)")
    }
}

// 标签按钮组件
struct TagButton: View {
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

// 攻略预览视图
struct GuidePreviewView: View {
    let title: String
    let content: String
    let city: String
    let tags: [String]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 封面和标题
                ZStack(alignment: .bottom) {
                    Color.gray.opacity(0.3)
                        .frame(height: 200)
                    
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(city)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                }
                
                // 内容
                VStack(alignment: .leading, spacing: 12) {
                    Text(content)
                        .padding()
                    
                    // 标签
                    if !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(tags, id: \.self) { tag in
                                    Text(tag)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("预览")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("关闭") {
                    // 关闭预览
                }
            }
        }
    }
}

#Preview {
    PublishGuideView()
}
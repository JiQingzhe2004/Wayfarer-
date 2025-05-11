//
//  SettingsView.swift
//  Wayfarer+
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var fadeIn = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("外观")) {
                    ForEach(AppColorScheme.allCases) { scheme in
                        Button(action: {
                            colorSchemeManager.selectedAppearance = scheme
                        }) {
                            HStack {
                                Text(scheme.rawValue)
                                Spacer()
                                if colorSchemeManager.selectedAppearance == scheme {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppColors.primary)
                                }
                            }
                        }
                        .foregroundColor(AppColors.text)
                    }
                }

                Section(header: Text("关于")) {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "未知")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }

                Section(header: Text("联系")) {
                    HStack {
                        Text("邮箱")
                        Spacer()
                        Text("jin648862@gmail.com")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .overlay(
                VStack {
                    if fadeIn {
                        Image("settings_pattern")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.78)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color.black.opacity(colorSchemeManager.selectedAppearance == .dark ? 0.1 : 0.2), radius: 6, x: 0, y: -2)
                            .transition(.opacity)
                            .padding(.bottom, 20)
                    }
                    Text("© 2025 Wayfarer Inc.")
                        .foregroundColor(AppColors.secondaryText)
                        .padding(.top, 10)
                    
                    HStack {
                        Spacer()
                        Text("制作人：Forrest")
                            .foregroundColor(AppColors.secondaryText)
                        Image("creator_avatar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .padding(.leading, 5) // 减小间隔
                        Spacer()
                    }
                    .padding(.top, 5)
                    .frame(maxWidth: .infinity, alignment: .center) // 确保居中
                },
                alignment: .bottom
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0)) {
                    fadeIn = true
                }
            }
            .background(AppColors.background.edgesIgnoringSafeArea(.all))
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("完成") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .preferredColorScheme(colorSchemeManager.selectedAppearance.colorScheme)
    }
}

#Preview {
    SettingsView()
}

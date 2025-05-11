//
//  SettingsView.swift
//  Wayfarer+
//
//  Created by Trae AI on 2025/5/10.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    @Environment(\.presentationMode) var presentationMode
    
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
                        Text("1.0.0")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
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
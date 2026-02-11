//
//  SettingsView.swift
//  UzaoCalculator
//

import SwiftUI

struct SettingsView: View {
    let badges: [Badge]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                // Section 1: うざおの記憶
                Section("うざおの記憶") {
                    NavigationLink {
                        BadgeListView(badges: badges)
                    } label: {
                        Label("獲得したバッジを見る", systemImage: "rosette")
                    }
                }

                // Section 2: 開発者への施し
                Section("開発者への施し") {
                    Button {
                        print("Purchase: Remove Ads")
                    } label: {
                        Label("広告を消し去る (¥160)", systemImage: "xmark.circle")
                    }

                    Button {
                        print("Purchase: Coffee")
                    } label: {
                        Label("開発者にコーヒーを奢る (¥320)", systemImage: "cup.and.saucer.fill")
                    }
                }

                // Section 3: アプリ情報
                Section("アプリ情報") {
                    HStack {
                        Text("バージョン")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(badges: [])
}

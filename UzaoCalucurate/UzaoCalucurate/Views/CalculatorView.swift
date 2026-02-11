//
//  CalculatorView.swift
//  UzaoCalculator
//
//  Created by AI Assistant
//

import SwiftUI

struct CalculatorView: View {
    @StateObject private var brain = UzaoBrain()
    @State private var showBadges: Bool = false
    
    let buttonRows: [[String]] = [
        ["C", "±", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        ZStack {
            // Background (Desk)
            Color(red: 0.2, green: 0.2, blue: 0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Badge Button (Top Right)
                HStack {
                    Spacer()
                    Button(action: {
                        showBadges = true
                    }) {
                        Image(systemName: "rosette")
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 0.85, green: 0.83, blue: 0.78))
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(Color(red: 0.85, green: 0.83, blue: 0.78))
                                    .shadow(color: Color.white.opacity(0.8), radius: 3, x: -2, y: -2)
                                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                            )
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                }
                
                Spacer()
                
                // Calculator Body
                VStack(spacing: 20) {
                    // LCD Display
                    DualLCDView(
                        uzaoMessage: brain.uzaoMessage,
                        displayValue: brain.displayValue
                    )
                    .padding(.top, 20)
                    
                    // Button Grid
                    GeometryReader { geometry in
                        let buttonWidth = (geometry.size.width - 36) / 4 // 3 spacings between 4 buttons
                        
                        VStack(spacing: 12) {
                            ForEach(Array(buttonRows.enumerated()), id: \.offset) { rowIndex, row in
                                HStack(spacing: 12) {
                                    ForEach(row, id: \.self) { button in
                                        if button == "0" {
                                            // Special case for "0" button (double width)
                                            NeumorphicButton(
                                                label: button,
                                                color: buttonColor(for: button)
                                            ) {
                                                brain.input(key: button)
                                            }
                                            .frame(width: buttonWidth * 2 + 12) // Double width + spacing
                                        } else {
                                            NeumorphicButton(
                                                label: button,
                                                color: buttonColor(for: button)
                                            ) {
                                                brain.input(key: button)
                                            }
                                            .frame(width: buttonWidth)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 320)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.85, green: 0.83, blue: 0.78))
                        .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Ad Space (Bottom)
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 50)
                    .overlay(
                        Text("広告スペース")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    )
                    .padding(.bottom, 0)
            }
        }
        .sheet(isPresented: $showBadges) {
            BadgeListView(badges: brain.badges)
        }
    }
    
    private func buttonColor(for label: String) -> Color {
        switch label {
        case "0"..."9", ".":
            return Color(red: 0.9, green: 0.9, blue: 0.9) // Off-white
        case "+", "-", "×", "÷", "=":
            return Color(red: 1.0, green: 0.6, blue: 0.2) // Orange
        case "C", "±", "%":
            return Color(red: 0.3, green: 0.3, blue: 0.3) // Dark Grey
        default:
            return Color(red: 0.9, green: 0.9, blue: 0.9)
        }
    }
}

// Badge List View
struct BadgeListView: View {
    let badges: [Badge]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.2, green: 0.2, blue: 0.2)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(badges) { badge in
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            badge.isUnlocked
                                                ? Color(red: 1.0, green: 0.6, blue: 0.2)
                                                : Color.gray.opacity(0.3)
                                        )
                                        .frame(width: 80, height: 80)
                                        .shadow(color: Color.white.opacity(0.8), radius: 3, x: -2, y: -2)
                                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                                    
                                    Image(systemName: badge.isUnlocked ? "checkmark.circle.fill" : "lock.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(badge.isUnlocked ? .white : .gray)
                                }
                                
                                Text(badge.type.displayName)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                
                                if badge.isUnlocked {
                                    Text(badge.unlockedMessage)
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.3, green: 0.3, blue: 0.3).opacity(0.5))
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("バッジ一覧")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    CalculatorView()
}

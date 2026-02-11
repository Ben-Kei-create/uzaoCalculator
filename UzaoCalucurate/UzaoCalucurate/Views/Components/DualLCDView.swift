//
//  DualLCDView.swift
//  UzaoCalculator
//
//  Created by AI Assistant
//

import SwiftUI

struct DualLCDView: View {
    let uzaoMessage: String
    let displayValue: String
    
    var body: some View {
        VStack(spacing: 12) {
            // Upper LCD (Sub Display) - Uzao Message
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.5, green: 0.6, blue: 0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black.opacity(0.3), lineWidth: 2)
                    )
                    .overlay(
                        // Inner shadow effect (recessed look)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.2),
                                        Color.clear
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .blur(radius: 4)
                            .offset(x: 2, y: 2)
                    )
                
                Text(uzaoMessage)
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.1))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 50)
            
            // Lower LCD (Main Display) - Calculation Result
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.6, green: 0.7, blue: 0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black.opacity(0.3), lineWidth: 2)
                    )
                    .overlay(
                        // Inner shadow effect (recessed look)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.2),
                                        Color.clear
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .blur(radius: 4)
                            .offset(x: 2, y: 2)
                    )
                
                HStack {
                    Spacer()
                    Text(displayValue)
                        .font(.system(size: 56, weight: .light, design: .monospaced))
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.05))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
            }
            .frame(height: 80)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    DualLCDView(
        uzaoMessage: "計算お疲れ様です。",
        displayValue: "12345.67"
    )
    .padding()
    .background(Color(red: 0.2, green: 0.2, blue: 0.2))
}

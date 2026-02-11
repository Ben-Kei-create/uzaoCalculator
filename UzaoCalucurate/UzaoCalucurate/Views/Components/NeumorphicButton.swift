//
//  NeumorphicButton.swift
//  UzaoCalculator
//
//  Created by AI Assistant
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct NeumorphicButton: View {
    let label: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button(action: {
#if canImport(UIKit)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
#endif
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
            
            action()
        }) {
            Text(label)
                .font(.system(size: 28, weight: .medium, design: .rounded))
                .foregroundColor(color == Color(red: 0.9, green: 0.9, blue: 0.9) ? .black : .white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    isPressed ? Color.black.opacity(0.3) : Color.white.opacity(0.8),
                                    isPressed ? Color.white.opacity(0.8) : Color.black.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: isPressed ? Color.black.opacity(0.3) : Color.white.opacity(0.8),
                    radius: isPressed ? 1 : 3,
                    x: isPressed ? 2 : -2,
                    y: isPressed ? 2 : -2
                )
                .shadow(
                    color: isPressed ? Color.white.opacity(0.8) : Color.black.opacity(0.3),
                    radius: isPressed ? 1 : 3,
                    x: isPressed ? -2 : 3,
                    y: isPressed ? -2 : 3
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HStack {
        NeumorphicButton(label: "7", color: Color(red: 0.9, green: 0.9, blue: 0.9)) {}
        NeumorphicButton(label: "+", color: Color(red: 1.0, green: 0.6, blue: 0.2)) {}
        NeumorphicButton(label: "C", color: Color(red: 0.3, green: 0.3, blue: 0.3)) {}
    }
    .padding()
    .background(Color(red: 0.2, green: 0.2, blue: 0.2))
}

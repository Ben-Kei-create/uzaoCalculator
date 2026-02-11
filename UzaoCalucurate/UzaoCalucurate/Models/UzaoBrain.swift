//
//  UzaoBrain.swift
//  UzaoCalculator
//
//  Created by AI Assistant
//

import Foundation
import SwiftUI

class UzaoBrain: ObservableObject {
    // MARK: - Published Properties
    @Published var displayValue: String = "0"
    @Published var uzaoMessage: String = "計算を始めましょう..."
    @Published var badges: [Badge] = []
    @Published var clickCount: Int = 0
    
    // MARK: - Private Properties
    private var currentInput: String = "0"
    private var previousValue: Double = 0
    private var operation: String? = nil
    private var shouldResetDisplay: Bool = false
    
    // MARK: - Uzao Messages Dictionary
    private let uzaoMessages: [String: String] = [
        "0": "無（ゼロ）。インドで発見された概念ですね。虚無です。",
        "1": "1は素数ではありません。定義を確認してくださいね。",
        "3.14": "円周率。パイでも食べて落ち着いたらどうです？",
        "256": "8bitの最大値。キリがいいですね（ニチャァ）。",
        "777": "確率論的にはただの数字ですが、おめでとうございます。",
        "9.8": "重力加速度。地球に縛られている証拠ですね。",
        "1192": "いい国作ろう？今は1185年説が有力ですよ。"
    ]
    
    private let defaultMessages: [String] = [
        "計算お疲れ様です。",
        "ふーん、そういう数字ですか。",
        "で？ って感じの数字ですね。"
    ]
    
    // MARK: - Initialization
    init() {
        initializeBadges()
    }
    
    private func initializeBadges() {
        badges = BadgeType.allCases.map { Badge(type: $0) }
    }
    
    // MARK: - Input Handling
    func input(key: String) {
        if shouldResetDisplay {
            currentInput = "0"
            shouldResetDisplay = false
        }
        
        switch key {
        case "0"..."9":
            if currentInput == "0" {
                currentInput = key
            } else {
                currentInput += key
            }
            displayValue = currentInput
            
        case ".":
            if !currentInput.contains(".") {
                currentInput += "."
                displayValue = currentInput
            }
            
        case "+", "-", "×", "÷":
            if let prevOp = operation {
                calculate()
            }
            previousValue = Double(currentInput) ?? 0
            operation = key
            shouldResetDisplay = true
            
        case "=":
            calculate()
            
        case "C":
            clear()
            
        case "±":
            if let value = Double(currentInput) {
                currentInput = String(-value)
                displayValue = currentInput
            }
            
        case "%":
            if let value = Double(currentInput) {
                currentInput = String(value / 100)
                displayValue = currentInput
            }
            
        default:
            break
        }
    }
    
    // MARK: - Calculation
    func calculate() {
        guard let op = operation else { return }
        
        let currentValue = Double(currentInput) ?? 0
        var result: Double = 0
        
        switch op {
        case "+":
            result = previousValue + currentValue
        case "-":
            result = previousValue - currentValue
        case "×":
            result = previousValue * currentValue
        case "÷":
            result = currentValue != 0 ? previousValue / currentValue : 0
        default:
            return
        }
        
        // Format result
        let resultString = formatResult(result)
        displayValue = resultString
        currentInput = resultString
        
        // Update click count
        clickCount += 1
        checkClickerBadge()
        
        // Check for badges
        checkBadge(result: resultString)
        
        // Generate uzao message
        generateUzaoMessage(for: resultString)
        
        operation = nil
        shouldResetDisplay = true
    }
    
    private func formatResult(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            // Limit decimal places
            let rounded = (value * 1000000).rounded() / 1000000
            return String(rounded)
        }
    }
    
    // MARK: - Uzao Message Generation
    private func generateUzaoMessage(for result: String) {
        if let message = uzaoMessages[result] {
            uzaoMessage = message
        } else {
            uzaoMessage = defaultMessages.randomElement() ?? "計算お疲れ様です。"
        }
    }
    
    // MARK: - Badge Checking
    func checkBadge(result: String) {
        guard let value = Double(result) else { return }
        
        // Check for prime number
        if isPrime(Int(value)) && value >= 2 {
            unlockBadge(type: .prime, message: "\(Int(value))は素数です。素晴らしい！")
        }
        
        // Check for soroban (same digits)
        if isSoroban(result) {
            unlockBadge(type: .soroban, message: "ゾロ目発見！\(result)")
        }
        
        // Check for physics constants
        if isPhysicsConstant(value) {
            unlockBadge(type: .physics, message: "物理定数を発見しました！")
        }
    }
    
    private func checkClickerBadge() {
        if clickCount >= 100 {
            unlockBadge(type: .clicker, message: "100回連続計算達成！")
        }
    }
    
    private func unlockBadge(type: BadgeType, message: String) {
        if let index = badges.firstIndex(where: { $0.type == type && !$0.isUnlocked }) {
            badges[index].isUnlocked = true
            badges[index].unlockedAt = Date()
            badges[index].unlockedMessage = message
        }
    }
    
    // MARK: - Helper Functions
    private func isPrime(_ n: Int) -> Bool {
        guard n >= 2 else { return false }
        guard n != 2 else { return true }
        guard n % 2 != 0 else { return false }
        
        var i = 3
        while i * i <= n {
            if n % i == 0 {
                return false
            }
            i += 2
        }
        return true
    }
    
    private func isSoroban(_ str: String) -> Bool {
        let digits = str.replacingOccurrences(of: ".", with: "")
        guard digits.count >= 2 else { return false }
        let firstChar = digits.first!
        return digits.allSatisfy { $0 == firstChar }
    }
    
    private func isPhysicsConstant(_ value: Double) -> Bool {
        // Check for common physics constants (with tolerance)
        let constants: [Double] = [3.14159, 2.71828, 9.8, 6.626, 1.602, 299792458]
        let tolerance = 0.01
        
        return constants.contains { abs($0 - value) < tolerance }
    }
    
    // MARK: - Clear
    func clear() {
        currentInput = "0"
        displayValue = "0"
        previousValue = 0
        operation = nil
        shouldResetDisplay = false
        uzaoMessage = "計算を始めましょう..."
    }
}

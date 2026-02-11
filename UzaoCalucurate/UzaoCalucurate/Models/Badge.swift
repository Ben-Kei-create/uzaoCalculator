//
//  Badge.swift
//  UzaoCalculator
//
//  Created by AI Assistant
//

import Foundation

enum BadgeType: String, CaseIterable {
    case prime = "prime"
    case soroban = "soroban"
    case physics = "physics"
    case clicker = "clicker"
    
    var displayName: String {
        switch self {
        case .prime:
            return "素数マスター"
        case .soroban:
            return "ゾロ目コレクター"
        case .physics:
            return "物理定数ハンター"
        case .clicker:
            return "連打の達人"
        }
    }
    
    var description: String {
        switch self {
        case .prime:
            return "素数を計算しました"
        case .soroban:
            return "ゾロ目を達成しました"
        case .physics:
            return "物理定数を発見しました"
        case .clicker:
            return "100回連続で計算しました"
        }
    }
}

struct Badge: Identifiable, Codable {
    let id: UUID
    let type: BadgeType
    var isUnlocked: Bool
    var unlockedAt: Date?
    var unlockedMessage: String
    
    init(id: UUID = UUID(), type: BadgeType, isUnlocked: Bool = false, unlockedAt: Date? = nil, unlockedMessage: String = "") {
        self.id = id
        self.type = type
        self.isUnlocked = isUnlocked
        self.unlockedAt = unlockedAt
        self.unlockedMessage = unlockedMessage
    }
}

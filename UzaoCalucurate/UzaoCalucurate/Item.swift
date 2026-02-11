//
//  Item.swift
//  UzaoCalucurate
//
//  Created by 茂木史明 on 2026/02/11.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

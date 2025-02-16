//
//  Item.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-16.
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

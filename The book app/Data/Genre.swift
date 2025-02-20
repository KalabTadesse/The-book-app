//
//  Genre.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-18.
//

import Foundation
import SwiftData

@Model
final class Genre {
    var name: String
    var books: [Book]?

    init(name: String) {
        self.name = name
    }
}

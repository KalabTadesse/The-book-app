//
//  Book data.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-16.
//

import Foundation
import SwiftData

@Model
final class Book {
    @Attribute(.unique) private(set) var id = UUID()
    var title: String
    var author: Author?
    var genre: Genre?
    var publicationYear: Int

    init(title: String, author: Author?, genre: Genre?, publicationYear: Int) {
        self.id = UUID() 
        self.title = title
        self.author = author
        self.genre = genre
        self.publicationYear = publicationYear
    }
}

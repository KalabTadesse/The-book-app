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
    @Attribute(.unique) var id = UUID()
    var title: String
    var author: Author?
    var genre: Genre?
    var publicationYear: String
    var coverURL: String?

    init(title: String, author: Author?, genre: Genre?, publicationYear: String, coverURL: String? = nil) {
        self.id = UUID() 
        self.title = title
        self.author = author
        self.genre = genre
        self.publicationYear = publicationYear
        self.coverURL = coverURL
    }
}

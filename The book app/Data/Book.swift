//
//  Book data.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-16.
//

import Foundation
import SwiftData
import Observation

@Model
final class Book{
    @Attribute(.unique) var id = UUID()
    var title: String
    var author: Author?
    var genre: Genre?
    var publicationYear: String
    var status: BookStatus
    var coverURL: String?
    enum BookStatus: String, Codable {
            case currentlyReading = "Currently Reading"
            case wantToRead = "Want to Read"
            case alreadyRead = "Already Read"
        }
    
    init(title: String, author: Author?, genre: Genre?, publicationYear: String, status: BookStatus,coverURL: String? = nil) {
        self.id = UUID()
        self.title = title
        self.author = author
        self.genre = genre
        self.publicationYear = publicationYear
        self.status = status
        self.coverURL = coverURL
    }
}

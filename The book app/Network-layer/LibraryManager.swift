//
//  LibraryManager.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-18.
//

import Foundation
import SwiftData

class LibraryManager {
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }

    func addBook(title: String, author: Author?, genre: Genre?, publicationYear: String) {
        let newBook = Book(title: title, author: author, genre: genre, publicationYear: publicationYear)
        context.insert(newBook)
    }

    func fetchBooks() -> [Book] {
        let descriptor = FetchDescriptor<Book>(sortBy: [SortDescriptor(\.title)])
        return (try? context.fetch(descriptor)) ?? []
    }

    func updateBook(book: Book, newTitle: String) {
        book.title = newTitle
    }

    func deleteBook(book: Book) {
        context.delete(book)
    }
}

//
//  LibraryViewModel.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-03-02.
//

import Foundation
import SwiftData
import Observation

@Observable
class LibraryViewModel{
    var searchText: String = ""
    var books: [Book] = []
    
    var modelContext: ModelContext  
    var libraryManager: LibraryManager
    
    init(context: ModelContext) {
           self.modelContext = context
           self.libraryManager = LibraryManager(context: context)
           fetchBooks()
       }
    
    func fetchBooks() {
           books = libraryManager.fetchBooks()
       }
    
    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func clearSearch() {
        searchText = ""
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for index in offsets {
            let bookToDelete = books[index]
            libraryManager.deleteBook(book: bookToDelete)
        }
        fetchBooks()
    }
}

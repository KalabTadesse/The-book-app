//
//  AddBookViewModel.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-03-06.
//

import Foundation
import SwiftData

@Observable
class AddBookViewModel {
    private let modelContext: ModelContext
    private let libraryViewModel: LibraryViewModel
    var googleBooksService = GoogleBooksService()
    
    var searchText: String = ""
    var selectedReadingStatus: ReadingStatus = .wantToRead

    init(modelContext: ModelContext, libraryViewModel: LibraryViewModel) {
        self.modelContext = modelContext
        self.libraryViewModel = libraryViewModel
    }
    
    func searchBooks() {
        Task {
            await googleBooksService.searchBooks(query: searchText)
        }
    }

    func addBookToLibrary(_ book: Book) {
        modelContext.insert(book)
        do {
            try modelContext.save()
            libraryViewModel.fetchBooks()
        } catch {
            print("Failed to save book: \(error.localizedDescription)")
        }
    }
    
    func clearSearch() {
        searchText = ""
    }
}


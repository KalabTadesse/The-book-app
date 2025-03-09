//
//  RecomendationViewModel.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-03-09.
//

import Foundation
import SwiftData

@Observable
class RecommendationViewModel {
    private let modelContext: ModelContext
    private let googleBooksService = GoogleBooksService()
    
    var recommendedBooks: [Book] = []

    init(context: ModelContext) {
        self.modelContext = context
    }
    
    func fetchRecommendations() {
        let descriptor = FetchDescriptor<Book>(sortBy: [SortDescriptor(\.title)])
        let books = (try? modelContext.fetch(descriptor)) ?? []
        
        let readGenres = Set(books.filter { $0.readingStatus == .read }
                                .compactMap { $0.genre?.name })
        
        guard let genre = readGenres.randomElement() else { return }
        
        Task {
            await fetchBooksForGenre(genre: genre)
        }
    }

    private func fetchBooksForGenre(genre: String) async {
        await googleBooksService.searchBooks(query: genre)
        await MainActor.run {
            self.recommendedBooks = googleBooksService.books
        }
    }
}

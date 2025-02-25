//
//  GoogleApi.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-22.
//

import Foundation
import SwiftData

class GoogleBooksService : ObservableObject{
    
    @Published var books: [Book] = []
    
    func searchBooks(query: String) async {
            guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(query)") else {
                print("Invalid URL")
                return
            }
            do {
                let fetchedBooks = try await fetchBooks(from: url)
                // Update the published property on the main thread.
                await MainActor.run {
                    self.books = fetchedBooks
                }
            } catch {
                print("Error fetching books: \(error)")
            }
        }
    
    func fetchBooks(from url: URL) async throws -> [Book] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let response = try decoder.decode(GoogleBookResponse.self, from: data)
        let books = response.items?.map { convert(googleBook: $0) } ?? []
        return books
    }
}
func convert(googleBook: GoogleBook) -> Book {
    let title = googleBook.volumeInfo.title ?? "Unknown Title"
    let authorName = googleBook.volumeInfo.authors?.first ?? "Unknown Author"
    let genreName = googleBook.volumeInfo.categories?.first ?? "Unknown Genre"
    let publicationYear = googleBook.volumeInfo.publishedDate.map { String($0.prefix(4)) } ?? "0"
    let coverURL = googleBook.volumeInfo.imageLinks?.thumbnail
    
    let author = Author(name: authorName)
    let genre = Genre(name: genreName)
    
    return Book(title: title, author: author, genre: genre, publicationYear: publicationYear, coverURL: coverURL)
}


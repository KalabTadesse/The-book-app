//
//  AddBookView.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-20.
//
import SwiftUI
import SwiftData

struct AddBookView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]

    @StateObject private var googleBooksAPI = GoogleBooksAPI()  // ✅ Google Books API Manager
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                // ✅ Search Bar with Clear Button
                HStack {
                    TextField("Search Google Books...", text: $searchText, onCommit: searchBooks)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    if !searchText.isEmpty {
                        Button(action: clearSearch) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
                
                List {
                    // ✅ Display Google Books Search Results
                    ForEach(googleBooksAPI.searchResults) { book in
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.headline)
                            Text("Author: \(book.author?.name ?? "Unknown")")
                                .font(.subheadline)
                            Text("Genre: \(book.genre?.name ?? "Unknown")")
                                .font(.subheadline)
                            Text("Published: \(book.publicationYear)")
                                .font(.subheadline)
                        }
                        .onTapGesture {
                            addBookToLibrary(book)
                        }
                    }
                }
            }
            .navigationTitle("Add Book")
        }
    }
    
    // ✅ Search on Commit
    private func searchBooks() {
        googleBooksAPI.searchBooks(query: searchText)
    }

    // ✅ Add Book to SwiftData
    private func addBookToLibrary(_ book: Book) {
        modelContext.insert(book)
        try? modelContext.save()
    }
    
    private func clearSearch() {
        searchText = ""
        googleBooksAPI.searchResults = []  // ✅ Clear search results
    }
}

#Preview {
    AddBookView()
        .modelContainer(for: Book.self, inMemory: true)
}

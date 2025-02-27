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

    @State private var googleBooksService = GoogleBooksService()
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            VStack {
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
                List(googleBooksService.books, id: \.id) { book in
                                   Text(book.title)
                                       .onTapGesture {
                                           addBookToLibrary(book)
                                       }
                               }

            }
            .navigationTitle("Add Book")
        }
    }
    
    private func searchBooks() {
        Task {
            await googleBooksService.searchBooks(query: searchText)
        }
    }

    private func addBookToLibrary(_ book: Book) {
        modelContext.insert(book)
        try? modelContext.save()
    }
    
    private func clearSearch() {
        searchText = ""
    }
}

#Preview {
    AddBookView()
         .modelContainer(for: [Book.self, Author.self, Genre.self], inMemory: true)
}

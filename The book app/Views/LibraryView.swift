//
//  ContentView.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-16.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @State private var searchText: String = ""

    private var libraryManager: LibraryManager{
        LibraryManager(context: modelContext)
    }
    
        var body: some View {
            NavigationStack {
                VStack {
                    HStack {
                        TextField("Search books...", text: $searchText)
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
                        ForEach(filteredBooks) { book in
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                Text("Author: \(book.author?.name ?? "Unknown")")
                                    .font(.subheadline)
                                Text("Genre: \(book.genre?.name ?? "Unknown")")
                                    .font(.subheadline)
                                Text("Published: \(book.publicationYear)")
                                    .font(.subheadline)
                                Text("Bookstatus: \(book.status)")
                                    .font(.subheadline)
                            }
                        }
                        .onDelete(perform: deleteBooks)
                    }
                }
                .navigationTitle("Library")
            }
        }
    
        private var filteredBooks: [Book] {
            if searchText.isEmpty {
                return books
            } else {
                return books.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            }
        }

        private func clearSearch() {
            searchText = ""
        }

        private func deleteBooks(at offsets: IndexSet) {
            for index in offsets {
                let bookToDelete = books[index]
                libraryManager.deleteBook(book: bookToDelete)
            }
        }
    }

#Preview {
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Book.self,
            Author.self,
            Genre.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            //test data from chat ------------------------------------------//
                    let fakeAuthor1 = Author(name: "J.K. Rowling")
                    let fakeAuthor2 = Author(name: "George Orwell")
                    let fakeGenre1 = Genre(name: "Fantasy")
                    let fakeGenre2 = Genre(name: "Dystopian")

                    let fakeBooks = [
                        Book(title: "Harry Potter and the Sorcerer's Stone", author: fakeAuthor1, genre: fakeGenre1, publicationYear: "1997"),
                        Book(title: "1984", author: fakeAuthor2, genre: fakeGenre2, publicationYear: "1949"),
                        Book(title: "Animal Farm", author: fakeAuthor2, genre: fakeGenre2, publicationYear: "1945")
                    ]

                    for book in fakeBooks {
                        container.mainContext.insert(book)
                    }
            //test data from chat ------------------------------------------//
            return container
        } catch {
            fatalError("Could not create ModelContainer: kalab \(error)")
        }
    }()
    
   LibraryView()
        .modelContainer(sharedModelContainer)
}




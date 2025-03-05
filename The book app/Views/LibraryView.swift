//
//  ContentView.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-16.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Bindable var viewModel: LibraryViewModel  

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search books...", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    if !viewModel.searchText.isEmpty {
                        Button(action: viewModel.clearSearch) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
                
                List {
                    ForEach(viewModel.filteredBooks) { book in
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.headline)
                            Text("Author: \(book.author?.name ?? "Unknown")")
                                .font(.subheadline)
                            Text("Genre: \(book.genre?.name ?? "Unknown")")
                                .font(.subheadline)
                            Text("Published: \(book.publicationYear)")
                                .font(.subheadline)
                            Picker("Reading Status", selection: Binding(
                                get: { book.readingStatus },
                                set: { newStatus in
                                    viewModel.updateReadingStatus(for: book, to: newStatus)
                                        }
                            )) {
                                ForEach(ReadingStatus.allCases, id: \.self) { status in
                                    Text(status.rawValue).tag(status)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    .onDelete(perform: viewModel.deleteBooks)
                }
            }
            .navigationTitle("Library")
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
            
            // Testdata
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
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    let viewModel = LibraryViewModel(context: sharedModelContainer.mainContext)

    return LibraryView(viewModel: viewModel)
        .modelContainer(sharedModelContainer)
}

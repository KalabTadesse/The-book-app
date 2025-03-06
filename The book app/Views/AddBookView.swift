//
//  AddBookView.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-20.
//

import SwiftUI
import SwiftData

struct AddBookView: View {
    @Bindable var viewModel: AddBookViewModel

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search Google Books...", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onSubmit(viewModel.searchBooks)

                    if !viewModel.searchText.isEmpty {
                        Button(action: viewModel.clearSearch) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }

                Picker("Reading Status", selection: $viewModel.selectedReadingStatus) {
                    ForEach(ReadingStatus.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }

                List(viewModel.googleBooksService.books, id: \.id) { book in
                    Button(action: {
                        viewModel.addBookToLibrary(book)
                    }) {
                        Text(book.title)
                    }
                }
            }
            .navigationTitle("Add Book")
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
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    let viewModel = LibraryViewModel(context: sharedModelContainer.mainContext)
    let addBookViewModel = AddBookViewModel(modelContext: sharedModelContainer.mainContext, libraryViewModel: viewModel)

    return AddBookView(viewModel: addBookViewModel)
        .modelContainer(sharedModelContainer)
}

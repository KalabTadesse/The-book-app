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
    @State private var selectedBook: Book?
    @State private var selectedReadingStatus: ReadingStatus = .wantToRead
    @State private var showReadingStatusPicker = false

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

                List(viewModel.googleBooksService.books, id: \.id) { book in
                    Button(action: {
                        selectedBook = book
                        selectedReadingStatus = book.readingStatus
                        showReadingStatusPicker = true
                    }) {
                        HStack {
                            Text(book.title)
                            Text(book.author?.name ?? "Unknown Author")
                            Spacer()
                            Image(systemName: "plus.circle")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Add Book test")
// sheet modifier came from appel devloper website  https://developer.apple.com/documentation/swiftui/view/sheet(ispresented:ondismiss:content:)
            .sheet(isPresented: $showReadingStatusPicker) {
                VStack {
                    Text("Choose Reading Status")
                        .font(.headline)
                        .padding()
// chat gave me the 3 lines of code https://chatgpt.com/share/67cc91a8-9c44-8010-81c4-9c1fe10ad4a1
                    Picker("Reading Status", selection: $selectedReadingStatus) {
                        ForEach(ReadingStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    Button("Add to Library") {
                        guard let book = selectedBook else { return }
                        
                        let newBook = Book(
                            title: book.title,
                            author: book.author,
                            genre: book.genre,
                            publicationYear: book.publicationYear,
                            coverURL: book.coverURL,
                            readingStatus: selectedReadingStatus
                        )

                        viewModel.addBookToLibrary(newBook)
                        showReadingStatusPicker = false
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                    .padding()
                }
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

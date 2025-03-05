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
    @Bindable var libraryViewModel : LibraryViewModel
    @Query private var books: [Book]

    @State private var googleBooksService = GoogleBooksService()
    @State private var searchText: String = ""
    @State private var selectedReadingStatus: ReadingStatus = .wantToRead

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search Google Books...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onSubmit(searchBooks)
                    
                    if !searchText.isEmpty {
                        Button(action: clearSearch) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
                
                Picker("Reading Status", selection: $selectedReadingStatus) {
                    ForEach(ReadingStatus.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                
                List(googleBooksService.books, id: \.id) { book in
                    Button(action: {
                        addBookToLibrary(book)
                    }) {
                        Text(book.title)
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
        do {
            try modelContext.save()
            libraryViewModel.fetchBooks()   
        } catch {
            print("Failed to save book: \(error.localizedDescription)")
        }
        print(books.map { $0.title })
    }
    
    private func clearSearch() {
        searchText = ""
    }
}

//#Preview {
//    AddBookView()
//         .modelContainer(for: [Book.self, Author.self, Genre.self], inMemory: true)
//}
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

    return AddBookView(libraryViewModel: viewModel)
        .modelContainer(sharedModelContainer)  
}

//
//  TabView.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-28.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var libraryViewModel: LibraryViewModel
    @State private var addBookViewModel: AddBookViewModel

    
    init(context: ModelContext) {
          let libraryVM = LibraryViewModel(context: context)
          _libraryViewModel = State(initialValue: libraryVM)
          _addBookViewModel = State(initialValue: AddBookViewModel(modelContext: context, libraryViewModel: libraryVM))
      }

    var body: some View {
        TabView {
            AddBookView(viewModel: addBookViewModel)
                .tabItem {
                    Label("Add book", systemImage: "plus.square.fill")
                }
            LibraryView(viewModel: libraryViewModel)
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
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

    return MainView(context: sharedModelContainer.mainContext)
        .modelContainer(sharedModelContainer)
}

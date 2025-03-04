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

    init(context: ModelContext) {
        _libraryViewModel = State(initialValue: LibraryViewModel(context: context))
    }

    var body: some View {
        TabView {
            AddBookView()
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

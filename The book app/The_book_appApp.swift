//
//  The_book_appApp.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-16.
//

import SwiftUI
import SwiftData

@main
struct The_book_appApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Book.self,
            Author.self,
            Genre.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView(context: sharedModelContainer.mainContext)
        }
        .modelContainer(sharedModelContainer)
    }
}


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
    
    var body: some View {
          TabView {
              AddBookView()
                  .tabItem {
                      Label("Add book", systemImage: "plus.square.fill")
                  }
              LibraryView(context: modelContext)
                  .tabItem {
                      Label("Libbrary", systemImage: "books.vertical.fill")
                  }
          }
      }
}

#Preview {
    MainView()
}

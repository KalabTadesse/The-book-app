//
//  TabView.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-28.
//

import SwiftUI
import SwiftData

struct MainView: View {
    var body: some View {
          TabView {
              AddBookView()
                  .tabItem {
                      Label("Add book", systemImage: "plus.square.fill")
                  }
              LibraryView()
                  .tabItem {
                      Label("Libbrary", systemImage: "books.vertical.fill")
                  }
          }
      }
}

#Preview {
    MainView()
}

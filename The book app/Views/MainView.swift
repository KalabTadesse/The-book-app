//
//  TabView.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-28.
//

import SwiftUI

struct MainView: View {
    var body: some View {
          TabView {
              AddBookView()
                  .tabItem {
                      Label("Cat", systemImage: "cat.fill")
                  }
              LibraryView()
                  .tabItem {
                      Label("Dog", systemImage: "dog.fill")
                  }
          }
      }
}

#Preview {
    MainView()
}

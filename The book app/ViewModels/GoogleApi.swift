//
//  GoogleApi.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-22.
//

import Foundation


class GoogleBooksAPI: ObservableObject {
    
    private(set) var isLoading = false
    private(set) var author: Author?
    private(set) var genre: Genre?
    private(set) var book: Book?
    
    private let baseURL = "https://www.googleapis.com/books/v1/volumes?q="
    
    func searchBooks(query: String) {
        guard let url = URL(string: "\(baseURL)\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
                DispatchQueue.main.async {
                    self.searchResults = decodedResponse.items.map { item in
                        Book(
                            title: item.volumeInfo.title,
                            author: Author(name: item.volumeInfo.authors?.first ?? "Unknown"),
                            genre: Genre(name: item.volumeInfo.categories?.first ?? "Unknown"),
                            publicationYear: item.volumeInfo.publishedDate?.prefix(4).map { String($0) }.flatMap { Int($0) } ?? 0
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

// ✅ Structs to decode JSON response
struct GoogleBooksResponse: Codable {
    let items: [GoogleBookItem]
}

struct GoogleBookItem: Codable {
    let volumeInfo: GoogleBookVolumeInfo
}

struct GoogleBookVolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let categories: [String]?
    let publishedDate: String?
}

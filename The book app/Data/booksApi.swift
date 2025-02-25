//
//  booksApi.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-25.
//
import Foundation
import SwiftData

struct GoogleBookResponse: Codable {
    let items: [GoogleBook]?
}

struct GoogleBook: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let publishedDate: String?
    let categories: [String]?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

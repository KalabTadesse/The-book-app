//
//  booksApi.swift
//  The book app
//
//  Created by Kalab Tadesse on 2025-02-25.
//
import Foundation
import SwiftData

struct GoogleBookResponse:Decodable {
    let items: [GoogleBook]?
}

struct GoogleBook: Decodable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable {
    let title: String?
    let authors: [String]?
    let publishedDate: String?
    let categories: [String]?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Decodable {
    let smallThumbnail: String?
    let thumbnail: String?
}

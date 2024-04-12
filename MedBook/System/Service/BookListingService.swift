//
//  BookListingService.swift
//  MedBook
//
//  Created by Sanath on 12/04/24.
//

import Foundation

protocol BookListingServiceLogic {
    typealias ActionCompletion = (Result<BookListingData, Error>) -> Void
    func searchBooks(searchText: String, pageOffset: Int, completion: @escaping ActionCompletion)
}

final class BookListingService: BookListingServiceLogic {
    private let networkManager: NetworkManager
    
    private let bookListingURLString = "https://openlibrary.org/search.json?title=%@&limit=%@&offset=%@"
    private let limit = 10
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func searchBooks(searchText: String, pageOffset: Int, completion: @escaping ActionCompletion) {
        let offset = String(pageOffset * limit)
        let limitString = String(limit)
        let urlString = String(format: bookListingURLString, searchText, limitString, offset)
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 1)))
            return
        }
        
        networkManager.request(fromURL: url) { (result: Result<BookListingData, Error>) in
            switch result {
            case let .success(bookListingData):
                completion(.success(bookListingData))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Network Model

struct BookListingData: Decodable {
    let docs: [BookDetails]
}

struct BookDetails: Decodable {
    let title: String?
    let ratingsAverage: Float?
    let ratingsCount: Int?
    let authorName: [String]
    let coverI: Int?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
        case authorName = "author_name"
        case coverI = "cover_i"
    }
}

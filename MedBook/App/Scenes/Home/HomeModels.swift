//
//  HomeModels.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

enum Home {
    
    // MARK: Use cases
    
    enum Logout {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }
    
    enum Search {
        struct Request {
            let searchText: String
            let fetchType: FetchType
        }
        
        struct Response {
            let bookListing: BookListingData
        }
        
        struct ViewModel {
            let books: [BookViewModel]
        }
    }
    
    enum FetchType {
        case initial
        case pagination
    }
}

struct BookViewModel: BookCellData {
    let title: String
    let ratingsAverage: String
    let ratingsCount: String
    let authorName: String
    let coverImageURLString: String
}

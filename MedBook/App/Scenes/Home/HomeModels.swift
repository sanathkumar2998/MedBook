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
            let books: [BookDetails]
            let bookmarkedKeys: [String]
        }
        
        struct ViewModel {
            let books: [BookViewModel]
        }
    }
    
    enum Bookmark {
        struct Request {
            let key: String?
        }
        
        struct Response {
            let key: String?
        }
        
        struct ViewModel {
            let key: String?
        }
    }
    
    enum FetchType {
        case initial
        case pagination
    }
}

struct BookViewModel: BookCellData {
    let key: String?
    let title: String
    let ratingsAverage: String
    let ratingsCount: String
    let authorName: String
    let coverImageURLString: String
    var isBookmarked: Bool
}

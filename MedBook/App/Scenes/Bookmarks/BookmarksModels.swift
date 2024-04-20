//
//  BookmarksModels.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

enum Bookmarks {
    
    // MARK: Use cases
    
    enum Model {
        struct Request {}
        
        struct Response {
            let bookmarks: [BookmarkDetails]
        }
        
        struct ViewModel {
            let books: [BookViewModel]
        }
    }
    
    enum RemoveBookmark {
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
}

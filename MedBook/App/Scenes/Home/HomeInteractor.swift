//
//  HomeInteractor.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import Foundation

protocol HomeBusinessLogic {
    func handleLogoutAction(request: Home.Logout.Request)
    func searchBooks(request: Home.Search.Request)
    func addBookmark(request: Home.Bookmark.Request)
    func removeBookmark(request: Home.Bookmark.Request)
    func refresh()
}

class HomeInteractor {
    private var presenter: HomePresentationLogic
    private var bookListingService: BookListingServiceLogic
    private var bookmarkDetailsDataStore: BookmarkDetailsDataStoreLogic
    
    private var pageOffset = 0
    private var apiInProgress = false
    private var searchText = ""
    private var bookDetails: [BookDetails] = []
    private var bookmarkedKeys: [String] = []
    
    init(presenter: HomePresentationLogic,
         bookListingService: BookListingServiceLogic,
         bookmarkDetailsDataStore: BookmarkDetailsDataStoreLogic) {
        self.presenter = presenter
        self.bookListingService = bookListingService
        self.bookmarkDetailsDataStore = bookmarkDetailsDataStore
    }
}

// MARK: - HomeBusinessLogic

extension HomeInteractor: HomeBusinessLogic {
    func handleLogoutAction(request: Home.Logout.Request) {
        UserDefaults.standard.saveIsLoggedIn(isLoggedIn: false)
        presenter.presentLogoutActionSuccessful(response: Home.Logout.Response())
    }
    
    func searchBooks(request: Home.Search.Request) {
        searchText = request.searchText
        switch request.fetchType {
        case .initial:
            pageOffset = 0
            fetchData(request: request)
        case .pagination:
            guard !apiInProgress else { return }
            
            apiInProgress = true
            pageOffset += 1
            fetchPaginatedData(searchText: request.searchText)
        }
    }
    
    func addBookmark(request: Home.Bookmark.Request) {
        let book = bookDetails.first { $0.key == request.key }
        guard let book else { return }
        
        addBookmark(book: book, key: request.key)
    }
    
    func removeBookmark(request: Home.Bookmark.Request) {
        removeBookmark(key: request.key)
    }
    
    func refresh() {
        fetchBookmarkedData { bookmarkedKeys in
            self.bookmarkedKeys = bookmarkedKeys
        }
    }
}

// MARK: - Private methods

private extension HomeInteractor {
    func fetchData(request: Home.Search.Request) {
        fetchBookmarkedData { bookmarkedKeys in
            self.bookmarkedKeys = bookmarkedKeys
            bookListingService.searchBooks(searchText: searchText,
                                           pageOffset: pageOffset) { [weak self] result in
                guard let self else { return }
                
                self.apiInProgress = false
                switch result {
                case let .success(bookListingData):
                    // If the response was not for the current searchText, then skip further execution.
                    guard self.searchText == request.searchText else { return }
                    
                    bookDetails = bookListingData.docs
                    let response = Home.Search.Response(books: bookListingData.docs,
                                                        bookmarkedKeys: bookmarkedKeys)
                    
                    self.presenter.presentBooksData(response: response)
                case let .failure(error):
                    debugPrint(error)
                }
            }
        }
    }
    
    func fetchPaginatedData(searchText: String) {
        bookListingService.searchBooks(searchText: searchText,
                                       pageOffset: pageOffset) { [weak self] result in
            guard let self else { return }
            
            self.apiInProgress = false
            switch result {
            case let .success(bookListingData):
                bookDetails.append(contentsOf: bookListingData.docs)
                let response = Home.Search.Response(books: bookListingData.docs,
                                                    bookmarkedKeys: self.bookmarkedKeys)
                self.presenter.presentPaginatedData(response: response)
            case let .failure(error):
                debugPrint(error)
            }
        }
    }
    
    func fetchBookmarkedData(completion: ([String]) -> Void) {
        bookmarkDetailsDataStore.fetchFromLocal { result in
            switch result {
            case let .success(bookmarkDetails):
                let bookmarkedKeys = bookmarkDetails.compactMap { $0.key }
                completion(bookmarkedKeys)
            case .failure:
                completion([])
            }
        }
    }
    
    func addBookmark(book: BookDetails, key: String?) {
        bookmarkDetailsDataStore.addBookmark(bookDetails: book) { result in
            switch result {
            case .success:
                let response = Home.Bookmark.Response(key: key)
                presenter.presentAddBookmarkSuccess(response: response)
            case let .failure(error):
                debugPrint(error)
            }
        }
    }
    
    func removeBookmark(key: String?) {
        bookmarkDetailsDataStore.removeBookmark(key: key ?? "") { result in
            switch result {
            case .success:
                let response = Home.Bookmark.Response(key: key)
                presenter.presentRemoveBookmarkSuccess(response: response)
            case let .failure(error):
                debugPrint(error)
            }
        }
    }
}

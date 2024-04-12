//
//  HomeInteractor.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import Foundation

protocol HomeBusinessLogic {
    func handleLogoutAction(request: Home.Logout.Request)
    func searchBooks(request: Home.Search.Request)
}

class HomeInteractor {
    private var presenter: HomePresentationLogic
    private var bookListingService: BookListingServiceLogic
    
    private var pageOffset = 0
    private var apiInProgress = false
    private var searchText = ""
    
    init(presenter: HomePresentationLogic,
         bookListingService: BookListingServiceLogic) {
        self.presenter = presenter
        self.bookListingService = bookListingService
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
}

// MARK: - Private methods

private extension HomeInteractor {
    func fetchData(request: Home.Search.Request) {
        bookListingService.searchBooks(searchText: searchText,
                                       pageOffset: pageOffset) { [weak self] result in
            guard let self else { return }
            
            self.apiInProgress = false
            switch result {
            case let .success(bookListingData):
                // If the response was not for the current searchText, then skip further execution.
                guard self.searchText == request.searchText else { return }
                
                let response = Home.Search.Response(bookListing: bookListingData)
                self.presenter.presentBooksData(response: response)
            case let .failure(error):
                debugPrint(error)
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
                let response = Home.Search.Response(bookListing: bookListingData)
                self.presenter.presentPaginatedData(response: response)
            case let .failure(error):
                debugPrint(error)
            }
        }
    }
}

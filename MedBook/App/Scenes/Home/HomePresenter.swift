//
//  HomePresenter.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol HomePresentationLogic {
    func presentLogoutActionSuccessful(response: Home.Logout.Response)
    func presentBooksData(response: Home.Search.Response)
    func presentPaginatedData(response: Home.Search.Response)
}


class HomePresenter: HomePresentationLogic {
    private weak var viewController: HomeDisplayLogic?
    
    private let coverImageAPI = "https://covers.openlibrary.org/b/id/%@-M.jpg"
    
    init(viewController: HomeDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentLogoutActionSuccessful(response: Home.Logout.Response) {
        let viewModel = Home.Logout.ViewModel()
        viewController?.displayLogoutActionSuccessful(viewModel: viewModel)
    }
    
    func presentBooksData(response: Home.Search.Response) {
        let books = convertToViewModel(response: response)
        let viewModel = Home.Search.ViewModel(books: books)
        viewController?.displayBooksData(viewModel: viewModel)
    }
    
    func presentPaginatedData(response: Home.Search.Response) {
        let books = convertToViewModel(response: response)
        let viewModel = Home.Search.ViewModel(books: books)
        viewController?.displayPaginatedData(viewModel: viewModel)
    }
    
    private func convertToViewModel(response: Home.Search.Response) -> [BookViewModel] {
        var books: [BookViewModel] = []
        response.bookListing.docs.forEach {
            var coverImageURLString: String = ""
            if let coverI = $0.coverI {
                coverImageURLString = String(format: coverImageAPI, String(coverI))
            }
            let ratingsAverage = String(format: "%.2f", $0.ratingsAverage ?? 0)
            let ratingsCount = String($0.ratingsCount ?? 0)
            let book = BookViewModel(title: $0.title ?? "",
                                     ratingsAverage: ratingsAverage,
                                     ratingsCount: ratingsCount,
                                     authorName: $0.authorName.first ?? "",
                                     coverImageURLString: coverImageURLString)
            books.append(book)
        }
        return books
    }
}

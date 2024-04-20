//
//  BookmarksPresenter.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol BookmarksPresentationLogic {
    func presentBookmarks(response: Bookmarks.Model.Response)
    func presentRemoveBookmarkSuccess(response: Bookmarks.RemoveBookmark.Response)
}


class BookmarksPresenter {
    private weak var viewController: BookmarksDisplayLogic?
    private let coverImageAPI = "https://covers.openlibrary.org/b/id/%@-M.jpg"
    
    init(viewController: BookmarksDisplayLogic) {
        self.viewController = viewController
    }
}

// MARK: - BookmarksPresentationLogic

extension BookmarksPresenter: BookmarksPresentationLogic {
    func presentBookmarks(response: Bookmarks.Model.Response) {
        let books = convertToViewModel(response: response)
        let viewModel = Bookmarks.Model.ViewModel(books: books)
        viewController?.displayBookmarks(viewModel: viewModel)
    }
    
    func presentRemoveBookmarkSuccess(response: Bookmarks.RemoveBookmark.Response) {
        let viewModel = Bookmarks.RemoveBookmark.ViewModel(key: response.key)
        viewController?.displayRemoveBookmarkSuccess(viewModel: viewModel)
    }
}

// MARK: - Private methods

private extension BookmarksPresenter {
    func convertToViewModel(response: Bookmarks.Model.Response) -> [BookViewModel] {
        var books: [BookViewModel] = []
        response.bookmarks.forEach {
            var coverImageURLString: String = ""
            coverImageURLString = String(format: coverImageAPI, String($0.coverI))
            let ratingsAverage = String(format: "%.2f", $0.ratingsAverage )
            let ratingsCount = String($0.ratingsCount )
            let key = $0.key
            let isBookmarked = true
            let book = BookViewModel(key: key,
                                     title: $0.title ?? "",
                                     ratingsAverage: ratingsAverage,
                                     ratingsCount: ratingsCount,
                                     authorName: $0.authorName ?? "",
                                     coverImageURLString: coverImageURLString,
                                     isBookmarked: isBookmarked)
            books.append(book)
        }
        return books
    }
}

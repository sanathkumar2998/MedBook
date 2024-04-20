//
//  BookmarksInteractor.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

protocol BookmarksBusinessLogic {
    func fetchBookmarks(request: Bookmarks.Model.Request)
    func removeBookmark(request: Bookmarks.RemoveBookmark.Request)
}

class BookmarksInteractor {
    private var presenter: BookmarksPresentationLogic
    private var bookmarkDetailsDataStore: BookmarkDetailsDataStoreLogic
    
    init(presenter: BookmarksPresentationLogic,
         bookmarkDetailsDataStore: BookmarkDetailsDataStoreLogic) {
        self.presenter = presenter
        self.bookmarkDetailsDataStore = bookmarkDetailsDataStore
    }
}

// MARK: - BookmarksBusinessLogic

extension BookmarksInteractor: BookmarksBusinessLogic {
    func fetchBookmarks(request: Bookmarks.Model.Request) {
        bookmarkDetailsDataStore.fetchFromLocal { result in
            switch result {
            case let .success(bookmarkDetails):
                let response = Bookmarks.Model.Response(bookmarks: bookmarkDetails)
                presenter.presentBookmarks(response: response)
            case let .failure(error):
                debugPrint(error)
            }
        }
    }
    
    func removeBookmark(request: Bookmarks.RemoveBookmark.Request) {
        removeBookmark(key: request.key)
    }
}

// MARK: - Private methods

private extension BookmarksInteractor {
    func removeBookmark(key: String?) {
        bookmarkDetailsDataStore.removeBookmark(key: key ?? "") { result in
            switch result {
            case .success:
                let response = Bookmarks.RemoveBookmark.Response(key: key)
                presenter.presentRemoveBookmarkSuccess(response: response)
            case let .failure(error):
                debugPrint(error)
            }
        }
    }
}

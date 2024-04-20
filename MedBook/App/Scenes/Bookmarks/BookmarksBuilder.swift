//
//  BookmarksBuilder.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol BookmarksSceneBuilder {
    func build() -> BookmarksViewController
}

class BookmarksBuilder: BookmarksSceneBuilder {
    // Add dependencies here
    
    func build() -> BookmarksViewController {
        let viewController: BookmarksViewController = UIStoryboard
            .makeViewController(name: BookmarksSceneConstants.bookmarksStoryboard,
                                identifier: BookmarksSceneConstants.bookmarksViewController)
        let presenter: BookmarksPresenter = BookmarksPresenter(viewController: viewController)

        // Inject dependencies into the interactor and create it.
        let bookmarkDetailsDataStore = BookmarkDetailsDataStore(coreData: CoreDataManager.shared)
        let interactor = BookmarksInteractor(presenter: presenter,
                                             bookmarkDetailsDataStore: bookmarkDetailsDataStore)
        
        let router: BookmarksRouter = BookmarksRouter(viewController: viewController)
                
        viewController.setInteractor(interactor: interactor)
        viewController.setRouter(router: router)
                
        return viewController
    }
}

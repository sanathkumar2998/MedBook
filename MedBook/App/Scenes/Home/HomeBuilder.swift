//
//  HomeBuilder.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

// If we have multiple dependencies, we should use a container.
//struct DependencyContainer {
//}

protocol HomeSceneBuilder {
    func build() -> HomeViewController
}

class HomeBuilder: HomeSceneBuilder {
    // Add dependencies here
    
    func build() -> HomeViewController {
        let viewController: HomeViewController = UIStoryboard
            .makeViewController(name: HomeSceneConstants.homeStoryboard,
                                identifier: HomeSceneConstants.homeViewController)
        let presenter: HomePresenter = HomePresenter(viewController: viewController)

        // Inject dependencies into the interactor and create it.
        let bookListingService = BookListingService(networkManager: NetworkManager.shared)
        let interactor = HomeInteractor(presenter: presenter,
                                        bookListingService: bookListingService)
        
        let router: HomeRouter = HomeRouter(viewController: viewController)
                
        viewController.setInteractor(interactor: interactor)
        viewController.setRouter(router: router)
                
        return viewController
    }
}

//
//  LoginBuilder.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

// If we have multiple dependencies, we should use a container.
//struct DependencyContainer {
//}

protocol LoginSceneBuilder {
    func build() -> LoginViewController
}

class LoginBuilder: LoginSceneBuilder {
    // Add dependencies here
    
    func build() -> LoginViewController {
        let viewController: LoginViewController = UIStoryboard
            .makeViewController(name: LoginSceneConstants.loginStoryboard,
                                identifier: LoginSceneConstants.loginViewController)
        let presenter: LoginPresenter = LoginPresenter(viewController: viewController)

        // Inject dependencies into the interactor and create it.
        let userDetailsDataStore = UserDetailsDataStore(coreData: CoreDataManager.shared)
        let interactor = LoginInteractor(presenter: presenter,
                                         userDetailsDataStore: userDetailsDataStore)
        
        let router: LoginRouter = LoginRouter(viewController: viewController)
                
        viewController.setInteractor(interactor: interactor)
        viewController.setRouter(router: router)
                
        return viewController
    }
}

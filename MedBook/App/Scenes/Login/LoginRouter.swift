//
//  LoginRouter.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit


class LoginRouter {
    private weak var viewController: LoginViewController?
    
    init(viewController: LoginViewController) {
        self.viewController = viewController
    }
}

extension LoginRouter {
    enum Destination {
        case home
    }
    
    func navigate(to destination: Destination) {
        navigateToHomeScreen()
    }
    
    private func navigateToHomeScreen() {
        let homeViewController = HomeBuilder().build()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController?.present(navigationController, animated: true)
    }
}


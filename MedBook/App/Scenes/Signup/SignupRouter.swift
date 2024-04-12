//
//  SignupRouter.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

class SignupRouter {
    private weak var viewController: SignupViewController?
    
    init(viewController: SignupViewController) {
        self.viewController = viewController
    }
}

extension SignupRouter {
    enum Destination {
        case home
    }
    
    func navigate(to destination: Destination) {
        switch destination {
        case .home:
            navigateToHomeScreen()
        }
    }
    
    private func navigateToHomeScreen() {
        let homeViewController = HomeBuilder().build()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController?.present(navigationController, animated: true)
    }
}


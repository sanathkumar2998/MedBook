//
//  LandingRouter.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

class LandingRouter {
    private weak var viewController: LandingViewController?
    
    init(viewController: LandingViewController) {
        self.viewController = viewController
    }
}

extension LandingRouter {
    enum Destination {
        case signup
        case login
    }
    
    func navigate(to destination: Destination) {
        switch destination {
        case .signup:
            navigateToSignupScreen()
        case .login:
            navigateToLoginScreen()
        }
    }
    
    func navigateToSignupScreen() {
        let signupViewController = SignupBuilder().build()
        viewController?.navigationController?.pushViewController(signupViewController, animated: true)
    }
    
    func navigateToLoginScreen() {
        let loginViewController = LoginBuilder().build()
        viewController?.navigationController?
            .pushViewController(loginViewController, animated: true)
    }
}


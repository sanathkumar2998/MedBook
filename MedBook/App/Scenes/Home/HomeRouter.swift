//
//  HomeRouter.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

class HomeRouter {
    private weak var viewController: HomeViewController?
    
    init(viewController: HomeViewController) {
        self.viewController = viewController
    }
}

extension HomeRouter {
    enum Destination {
        case landing
    }
    
    func navigate(to destination: Destination) {
        switch destination {
        case .landing:
            navigateToLandingScreen()
        }
    }
    
    private func navigateToLandingScreen() {
        viewController?.navigationController?.popToRootViewController(animated: true)
        viewController?.navigationController?.viewControllers = [LandingBuilder().build()]
    }
}


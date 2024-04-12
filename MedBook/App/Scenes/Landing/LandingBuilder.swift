//
//  LandingBuilder.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol LandingSceneBuilder {
    func build() -> LandingViewController
}

class LandingBuilder: LandingSceneBuilder {
    // Add dependencies here
    
    func build() -> LandingViewController {
        let viewController: LandingViewController = UIStoryboard
            .makeViewController(name: LandingSceneConstants.landingStoryboard,
                                identifier: LandingSceneConstants.landingViewController)

        
        let router: LandingRouter = LandingRouter(viewController: viewController)
        viewController.setRouter(router: router)
                
        return viewController
    }
}

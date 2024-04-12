//
//  SignupBuilder.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol SignupSceneBuilder {
    func build() -> SignupViewController
}

class SignupBuilder: SignupSceneBuilder {
    // Add dependencies here
    
    func build() -> SignupViewController {
        let viewController: SignupViewController = UIStoryboard
            .makeViewController(name: SignupSceneConstants.signupStoryboard,
                                identifier: SignupSceneConstants.signupViewController)
        let presenter: SignupPresenter = SignupPresenter(viewController: viewController)

        // Inject dependencies into the interactor and create it.
        let countriesService = CountriesService(networkManager: NetworkManager.shared)
        let countryDetailsDataStore = CountryDetailsDataStore(coreData: CoreDataManager.shared)
        let countriesProvider = CountriesDataProvider(service: countriesService,
                                                      countryDetailsDataStore: countryDetailsDataStore)
        
        let geolocationService = GeolocationService(networkManager: NetworkManager.shared)
        let geolocationProvider = GeolocationDataProvider(service: geolocationService)
        
        let userDetailsDataStore = UserDetailsDataStore(coreData: CoreDataManager.shared)
        let interactor = SignupInteractor(presenter: presenter,
                                          countriesProvider: countriesProvider,
                                          geolocationProvider: geolocationProvider,
                                          userDetailsDataStore: userDetailsDataStore)
        
        let router: SignupRouter = SignupRouter(viewController: viewController)
                
        viewController.setInteractor(interactor: interactor)
        viewController.setRouter(router: router)
                
        return viewController
    }
}

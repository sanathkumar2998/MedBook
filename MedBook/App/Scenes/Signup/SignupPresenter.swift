//
//  SignupPresenter.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol SignupPresentationLogic {
    func presentCountriesData(response: Signup.Countries.Response)
    func presentSaveSuccess(response: Signup.Save.Response)
    func presentUserAlreadyExistsError(response: Signup.Save.Response)
}


class SignupPresenter {
    private weak var viewController: SignupDisplayLogic?
    
    init(viewController: SignupDisplayLogic) {
        self.viewController = viewController
    }
}

// MARK: - SignupPresentationLogic

extension SignupPresenter: SignupPresentationLogic {
    func presentCountriesData(response: Signup.Countries.Response) {
        var countries: [CountryViewModel] = []
        for item in response.countries.data {
            let country = CountryViewModel(countryName: item.value.country,
                                           countryCode: item.key)
            countries.append(country)
        }
        let viewModel = Signup.Countries
            .ViewModel(countries: countries,
                       defaultCountryCode: response.geolocation.countryCode)
        viewController?.displayCountriesData(viewModel: viewModel)
    }
    
    func presentSaveSuccess(response: Signup.Save.Response) {
        let viewModel = Signup.Save.ViewModel()
        viewController?.displaySaveSuccess(viewModel: viewModel)
    }
    
    func presentUserAlreadyExistsError(response: Signup.Save.Response) {
        let viewModel = Signup.Save.ViewModel()
        viewController?.displayUserAlreadyExistsError(viewModel: viewModel)
    }
}

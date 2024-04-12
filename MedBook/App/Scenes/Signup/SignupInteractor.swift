//
//  SignupInteractor.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import CoreData

protocol SignupBusinessLogic {
    func fetchCountriesData(request: Signup.Countries.Request)
    func saveUserDetails(request: Signup.Save.Request)
}

class SignupInteractor {
    private var presenter: SignupPresentationLogic
    private var countriesProvider: CountriesDataProviderLogic
    private var geolocationProvider: GeolocationDataProviderLogic
    private var userDetailsDataStore: UserDetailsDataStoreLogic
    
    init(presenter: SignupPresentationLogic,
         countriesProvider: CountriesDataProviderLogic,
         geolocationProvider: GeolocationDataProviderLogic,
         userDetailsDataStore: UserDetailsDataStoreLogic) {
        self.presenter = presenter
        self.countriesProvider = countriesProvider
        self.geolocationProvider = geolocationProvider
        self.userDetailsDataStore = userDetailsDataStore
    }
}

// MARK: - SignupBusinessLogic

extension SignupInteractor: SignupBusinessLogic {
    func fetchCountriesData(request: Signup.Countries.Request) {
        let dispatchGroup = DispatchGroup()
        var geolocation: Geolocation?
        var countries: CountryData?
        
        dispatchGroup.enter()
        geolocationProvider.fetchUserLocation { result in
            switch result {
            case let .success(data):
                geolocation = data
            case .failure:
                break
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        countriesProvider.fetchCountries { result in
            switch result {
            case let .success(data):
                countries = data
            case .failure:
                break
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self, let geolocation, let countries else {
                return
            }
            
            let response = Signup.Countries
                .Response(countries: countries,
                          geolocation: geolocation)
            self.presenter.presentCountriesData(response: response)
        }
    }
    
    func saveUserDetails(request: Signup.Save.Request) {
        userDetailsDataStore.checkIfUserExists(email: request.email) { result in
            switch result {
            case let .success(emailExists):
                if emailExists {
                    presenter.presentUserAlreadyExistsError(response: Signup.Save.Response())
                } else {
                    insertUser(request: request)
                }
            case .failure:
                break
            }
        }
    }
}

// MARK: - Private methods

private extension SignupInteractor {
    func insertUser(request: Signup.Save.Request) {
        userDetailsDataStore.insertUser(email: request.email,
                                        password: request.password,
                                        country: request.country) { result in
            switch result {
            case .success:
                UserDefaults.standard
                    .saveIsLoggedIn(isLoggedIn: true)
                presenter.presentSaveSuccess(response: Signup.Save.Response())
            case .failure:
                break
            }
        }
    }
}

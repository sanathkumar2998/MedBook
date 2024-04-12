//
//  LoginInteractor.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import Foundation

protocol LoginBusinessLogic {
    func verifyUser(request: Login.Verify.Request)
}

class LoginInteractor {
    private var presenter: LoginPresentationLogic
    private var userDetailsDataStore: UserDetailsDataStoreLogic
    
    init(presenter: LoginPresentationLogic,
         userDetailsDataStore: UserDetailsDataStoreLogic) {
        self.presenter = presenter
        self.userDetailsDataStore = userDetailsDataStore
    }
    
}

// MARK: - LoginBusinessLogic

extension LoginInteractor: LoginBusinessLogic {
    func verifyUser(request: Login.Verify.Request) {
        userDetailsDataStore
            .checkIfUserExists(email: request.email,
                               password: request.password) { result in
                switch result {
                case let .success(userExists):
                    if userExists {
                        UserDefaults.standard
                            .saveIsLoggedIn(isLoggedIn: true)
                        presenter.presentUserVerificationSuccessful(response: Login.Verify.Response())
                    } else {
                        presenter.presentUserVerificationFailure(response: Login.Verify.Response())
                    }
                case .failure:
                    presenter.presentUserVerificationFailure(response: Login.Verify.Response())
                }
            }
    }
}

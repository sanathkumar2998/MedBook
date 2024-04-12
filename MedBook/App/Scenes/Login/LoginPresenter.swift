//
//  LoginPresenter.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol LoginPresentationLogic {
    func presentUserVerificationSuccessful(response: Login.Verify.Response)
    func presentUserVerificationFailure(response: Login.Verify.Response)
}


class LoginPresenter: LoginPresentationLogic {
    private weak var viewController: LoginDisplayLogic?
    
    init(viewController: LoginDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentUserVerificationSuccessful(response: Login.Verify.Response) {
        let viewModel = Login.Verify.ViewModel()
        viewController?.displayUserVerificationSuccessful(viewModel: viewModel)
    }
    
    func presentUserVerificationFailure(response: Login.Verify.Response) {
        let viewModel = Login.Verify.ViewModel()
        viewController?.displayUserVerificationFailure(viewModel: viewModel)
    }
}

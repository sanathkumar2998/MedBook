//
//  LandingViewController.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

class LandingViewController: UIViewController {
    @IBOutlet private var signupButton: UIButton!
    @IBOutlet private var loginButton: UIButton!
    
    private var router: LandingRouter?
    
    // MARK: Injection
    
    func setRouter(router: LandingRouter?) {
        self.router = router
    }
    
    @IBAction private func handleSignupAction() {
        // Route to Signup Screen
        router?.navigate(to: .signup)
    }
    
    @IBAction private func handleLoginAction() {
        // Route to Login Screen
        router?.navigate(to: .login)
    }
}

//
//  LoginViewController.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol LoginDisplayLogic: AnyObject {
    func displayUserVerificationSuccessful(viewModel: Login.Verify.ViewModel)
    func displayUserVerificationFailure(viewModel: Login.Verify.ViewModel)
}

class LoginViewController: UIViewController {
    
    @IBOutlet private var emailTextField: TextField!
    @IBOutlet private var passwordTextField: TextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var containerView: UIView!
        
    private var interactor: LoginBusinessLogic?
    private var router: LoginRouter?
    
    // MARK: Injection
    
    func setInteractor(interactor: LoginBusinessLogic?) {
        self.interactor = interactor
    }
    
    func setRouter(router: LoginRouter?) {
        self.router = router
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    @IBAction func emailChanged(_ sender: Any) {
        if let text = emailTextField.text {
            updateErrorTextForEmail(email: text)
        }
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        if let text = passwordTextField.text {
            updateErrorTextForPassword(password: text)
        }
    }
    
    @IBAction private func handleLoginAction() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        let request = Login.Verify
            .Request(email: email, password: password)
        interactor?.verifyUser(request: request)
    }
}

// MARK: - Private methods

private extension LoginViewController {
    func setup() {
        setupNavBarBackButton()
    }
    
    func setupNavBarBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(named: LoginStringConstants.chevronLeftImageName),
                                         style: .plain,
                                         target: self,
                                         action: nil)
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func updateErrorTextForEmail(email: String) {
        let errorText: String
        if !email.isValidEmail() {
            errorText = LoginStringConstants.invalidEmailText
        } else {
            errorText = ""
        }
        emailTextField.errorText = errorText
    }
    
    func updateErrorTextForPassword(password: String) {
        let errorText: String
        if password.count < 8 {
            errorText = LoginStringConstants.characterCountErrorText
        } else if password.containsDigit() {
            errorText = LoginStringConstants.digitErrorText
        } else if password.containsUppercase() {
            errorText = LoginStringConstants.uppercaseErrorText
        } else if password.containsSpecialCharacter() {
            errorText = LoginStringConstants.specialCharacterErrorText
        } else {
            errorText = ""
        }
        passwordTextField.errorText = errorText
    }
    
    func updateLoginButton() {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            let nonEmptyData = !email.isEmpty && !password.isEmpty
            let validData = emailTextField.errorText.isEmpty && passwordTextField.errorText.isEmpty
            loginButton.isEnabled = nonEmptyData && validData
        }
        
    }
}

// MARK: - LoginDisplayLogic

extension LoginViewController: LoginDisplayLogic {
    func displayUserVerificationSuccessful(viewModel: Login.Verify.ViewModel) {
        router?.navigate(to: .home)
    }
    
    func displayUserVerificationFailure(viewModel: Login.Verify.ViewModel) {
        let alert = UIAlertController(title: LoginStringConstants.alertTitle,
                                      message: LoginStringConstants.alertMessage,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: LoginStringConstants.alertActionTitle,
                                        style: .cancel)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            updateLoginButton()
            textField.resignFirstResponder()
        }
        return false
    }
}

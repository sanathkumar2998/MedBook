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
    @IBOutlet private var characterCountCheckbox: CheckboxWithTitle!
    @IBOutlet private var digitCheckbox: CheckboxWithTitle!
    @IBOutlet private var upperCaseCheckbox: CheckboxWithTitle!
    @IBOutlet private var specialCharacterCheckbox: CheckboxWithTitle!
        
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
        updateLoginButton()
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        if let text = passwordTextField.text {
            updatePasswordValidationCheckboxes(password: text)
        }
        updateLoginButton()
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
        setupPasswordTextField()
        setupPasswordCheckboxes()
    }
    
    func setupNavBarBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(named: LoginStringConstants.chevronLeftImageName),
                                         style: .plain,
                                         target: self,
                                         action: nil)
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setupPasswordTextField() {
        passwordTextField.enableShowPasswordButton()
    }
    
    func setupPasswordCheckboxes() {
        characterCountCheckbox.setTitle(title: SignupStringConstants.characterCountRequirementText)
        digitCheckbox.setTitle(title: SignupStringConstants.digitRequirementText)
        upperCaseCheckbox.setTitle(title: SignupStringConstants.uppercaseRequirementText)
        specialCharacterCheckbox.setTitle(title: SignupStringConstants.specialCharacterRequirementText)
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
    
    func updateLoginButton() {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            let isEmailValid = email.isValidEmail()
            let isPasswordValid = isPasswordValid(password: password)
            loginButton.isEnabled = isEmailValid && isPasswordValid
        }
    }
    
    func updatePasswordValidationCheckboxes(password: String) {
        if password.count < 8 {
            characterCountCheckbox.setChecked(checked: false)
        } else {
            characterCountCheckbox.setChecked(checked: true)
        }
        
        if !password.containsDigit() {
            digitCheckbox.setChecked(checked: false)
        } else {
            digitCheckbox.setChecked(checked: true)
        }
        
        if !password.containsUppercase() {
            upperCaseCheckbox.setChecked(checked: false)
        } else {
            upperCaseCheckbox.setChecked(checked: true)
        }
        
        if !password.containsSpecialCharacter() {
            specialCharacterCheckbox.setChecked(checked: false)
        } else {
            specialCharacterCheckbox.setChecked(checked: true)
        }
    }
    
    func isPasswordValid(password: String) -> Bool {
        var isValidPassword = true
        if password.count < 8 {
            isValidPassword = false
        } else if !password.containsDigit() {
            isValidPassword = false
        } else if !password.containsUppercase() {
            isValidPassword = false
        } else if !password.containsSpecialCharacter() {
            isValidPassword = false
        }
        return isValidPassword
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
            textField.resignFirstResponder()
        }
        return false
    }
}

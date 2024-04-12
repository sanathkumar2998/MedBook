//
//  SignupViewController.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol SignupDisplayLogic: AnyObject {
    func displayCountriesData(viewModel: Signup.Countries.ViewModel)
    func displaySaveSuccess(viewModel: Signup.Save.ViewModel)
    func displayUserAlreadyExistsError(viewModel: Signup.Save.ViewModel)
}

class SignupViewController: UIViewController {
    
    @IBOutlet private var emailTextField: TextField!
    @IBOutlet private var passwordTextField: TextField!
    @IBOutlet private var passwordRequirementsLabel: UILabel!
    @IBOutlet private var countryPicker: PickerView!
    @IBOutlet private var signupButton: UIButton!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
        
    private var interactor: SignupBusinessLogic?
    private var router: SignupRouter?
    
    private var selectedCountry: String?
    
    // MARK: Injection
    
    func setInteractor(interactor: SignupBusinessLogic?) {
        self.interactor = interactor
    }
    
    func setRouter(router: SignupRouter?) {
        self.router = router
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        fetchCountriesData()
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
    
    @IBAction private func handleSignupAction() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let country = selectedCountry else {
            return
        }
        
        let request = Signup.Save
            .Request(email: email,
                     password: password,
                     country: country)
        interactor?.saveUserDetails(request: request)
    }
}

// MARK: - Private methods

private extension SignupViewController {
    func setup() {
        setupNavBarBackButton()
        setupPasswordRequirementsLabel()
        setupCountryPicker()
        toggleActivityIndicator(show: true)
    }
    
    func setupNavBarBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(named: SignupStringConstants.chevronLeftImageName),
                                         style: .plain,
                                         target: self,
                                         action: nil)
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setupPasswordRequirementsLabel() {
        passwordRequirementsLabel.text = [
            SignupStringConstants.passwordRequirementText,
            SignupStringConstants.characterCountRequirementText,
            SignupStringConstants.digitRequirementText,
            SignupStringConstants.uppercaseRequirementText,
            SignupStringConstants.specialCharacterRequirementText
        ].joined(separator: SignupStringConstants.separator)
    }
    
    func setupCountryPicker() {
        countryPicker.pickerViewDelegate = self
    }
    
    func fetchCountriesData() {
        interactor?.fetchCountriesData(request: Signup.Countries.Request())
    }
    
    func updateSignupButton() {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            let nonEmptyData = !email.isEmpty && !password.isEmpty
            let validData = emailTextField.errorText.isEmpty && passwordTextField.errorText.isEmpty
            signupButton.isEnabled = nonEmptyData && validData
        }
        
    }
    
    func updateErrorTextForEmail(email: String) {
        let errorText: String
        if !email.isValidEmail() {
            errorText = SignupStringConstants.invalidEmailText
        } else {
            errorText = ""
        }
        emailTextField.errorText = errorText
    }
    
    func updateErrorTextForPassword(password: String) {
        let errorText: String
        if password.count < 8 {
            errorText = SignupStringConstants.characterCountErrorText
        } else if password.containsDigit() {
            errorText = SignupStringConstants.digitErrorText
        } else if password.containsUppercase() {
            errorText = SignupStringConstants.uppercaseErrorText
        } else if password.containsSpecialCharacter() {
            errorText = SignupStringConstants.specialCharacterErrorText
        } else {
            errorText = ""
        }
        passwordTextField.errorText = errorText
    }
    
    func toggleActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
            containerView.layer.opacity = 0.3
        } else {
            activityIndicator.stopAnimating()
            containerView.layer.opacity = 1.0
        }
    }
}

// MARK: - SignupDisplayLogic

extension SignupViewController: SignupDisplayLogic {
    func displayCountriesData(viewModel: Signup.Countries.ViewModel) {
        toggleActivityIndicator(show: false)
        countryPicker.dataArray = viewModel.countries
        let selectedTitle = viewModel.countries.first { $0.countryCode == viewModel.defaultCountryCode }?.title
        countryPicker.selectTitle(title: selectedTitle ?? "")
    }
    
    func displaySaveSuccess(viewModel: Signup.Save.ViewModel) {
        router?.navigate(to: .home)
    }
    
    func displayUserAlreadyExistsError(viewModel: Signup.Save.ViewModel) {
        let alert = UIAlertController(title: SignupStringConstants.alertTitle,
                                      message: SignupStringConstants.alertMessage,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: SignupStringConstants.alertActionTitle,
                                        style: .cancel)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            updateSignupButton()
            textField.resignFirstResponder()
        }
        return false
    }
}

// MARK: - PickerViewDelegate

extension SignupViewController: PickerViewDelegate {
    func pickerView(_ pickerView: PickerView, didSelectData data: String) {
        selectedCountry = data
    }
}

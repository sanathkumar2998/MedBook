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
    @IBOutlet private var characterCountCheckbox: CheckboxWithTitle!
    @IBOutlet private var digitCheckbox: CheckboxWithTitle!
    @IBOutlet private var upperCaseCheckbox: CheckboxWithTitle!
    @IBOutlet private var specialCharacterCheckbox: CheckboxWithTitle!
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
        updateSignupButton()
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        if let text = passwordTextField.text {
            updatePasswordValidationCheckboxes(password: text)
        }
        updateSignupButton()
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
        setupPasswordTextField()
        setupPasswordCheckboxes()
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
    
    func setupPasswordTextField() {
        passwordTextField.enableShowPasswordButton()
    }
    
    func setupPasswordCheckboxes() {
        characterCountCheckbox.setTitle(title: SignupStringConstants.characterCountRequirementText)
        digitCheckbox.setTitle(title: SignupStringConstants.digitRequirementText)
        upperCaseCheckbox.setTitle(title: SignupStringConstants.uppercaseRequirementText)
        specialCharacterCheckbox.setTitle(title: SignupStringConstants.specialCharacterRequirementText)
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
            let isEmailValid = email.isValidEmail()
            let isPasswordValid = isPasswordValid(password: password)
            signupButton.isEnabled = isEmailValid && isPasswordValid
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
    
    func toggleActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
            containerView.layer.opacity = 0.3
        } else {
            activityIndicator.stopAnimating()
            containerView.layer.opacity = 1.0
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

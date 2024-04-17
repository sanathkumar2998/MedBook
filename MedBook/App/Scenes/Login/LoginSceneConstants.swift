//
//  LoginSceneConstants.swift
//  MedBook
//
//  Created by Sanath on 11/04/24.
//

import Foundation

enum LoginSceneConstants {
    static let loginStoryboard = "Login"
    static let loginViewController = "LoginViewController"
}

enum LoginStringConstants {
    // Invalid Email Error
    static let invalidEmailText = "Invalid Email Address"
    
    // Password Requirements
    static let characterCountRequirementText = "At least 8 characters"
    static let digitRequirementText = "Must contain a number"
    static let uppercaseRequirementText = "Must contain an uppercase letter"
    static let specialCharacterRequirementText = "Must contain a special character"    
    
    // Chevron Left Image
    static let chevronLeftImageName = "chevron.left"
    
    // Failure to Log in Alert
    static let alertTitle = "Failed to log in"
    static let alertMessage = "Wrong username or password. Please try again."
    static let alertActionTitle = "Dismiss"
}

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
    
    // Invalid Password Error
    static let characterCountErrorText = "Password must contain at least 8 characters"
    static let digitErrorText = "Password must contain at least 1 digit"
    static let uppercaseErrorText = "Password must contain at least 1 uppercase character"
    static let specialCharacterErrorText = "Password must contain at least 1 special character"
    
    
    // Chevron Left Image
    static let chevronLeftImageName = "chevron.left"
    
    // Failure to Log in Alert
    static let alertTitle = "Failed to log in"
    static let alertMessage = "Wrong username or password. Please try again."
    static let alertActionTitle = "Dismiss"
}

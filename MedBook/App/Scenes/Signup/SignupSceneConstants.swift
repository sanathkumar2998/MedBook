//
//  SignupSceneConstants.swift
//  MedBook
//
//  Created by Sanath on 08/04/24.
//

enum SignupSceneConstants {
    static let signupStoryboard = "Signup"
    static let signupViewController = "SignupViewController"
}

enum SignupStringConstants {
    // Password Requirements
    static let characterCountRequirementText = "At least 8 characters"
    static let digitRequirementText = "Must contain a number"
    static let uppercaseRequirementText = "Must contain an uppercase letter"
    static let specialCharacterRequirementText = "Must contain a special character"
    
    // Invalid Email Error
    static let invalidEmailText = "Invalid Email Address"
    
    // Invalid Password Error
    static let characterCountErrorText = "Password must contain at least 8 characters"
    static let digitErrorText = "Password must contain at least 1 digit"
    static let uppercaseErrorText = "Password must contain at least 1 uppercase character"
    static let specialCharacterErrorText = "Password must contain at least 1 special character"
    
    // Chevron Left Image
    static let chevronLeftImageName = "chevron.left"
    
    // User already exists Alert
    static let alertTitle = "Failed to Sign up"
    static let alertMessage = "User already exists."
    static let alertActionTitle = "Dismiss"
}

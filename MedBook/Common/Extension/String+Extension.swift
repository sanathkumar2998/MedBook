//
//  String+Extension.swift
//  MedBook
//
//  Created by Sanath on 10/04/24.
//

import Foundation

extension String {
    /// email validation with regular expression
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func containsDigit() -> Bool {
        let regularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: self)
    }
    
    func containsUppercase() -> Bool {
        let regularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: self)
    }
    
    func containsSpecialCharacter() -> Bool {
        let regularExpression = ".*[^A-Za-z0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: self)
    }
}

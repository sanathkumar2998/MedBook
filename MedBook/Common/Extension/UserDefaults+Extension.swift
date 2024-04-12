//
//  UserDefaults+Extension.swift
//  MedBook
//
//  Created by Sanath on 11/04/24.
//

import Foundation

extension UserDefaults {
    enum Keys: String {
        case defaultCountryCode
        case isLoggedIn
    }
    
    func fetchCountryCode() -> String? {
        string(forKey: UserDefaults.Keys.defaultCountryCode.rawValue)
    }
    
    func saveCountryCode(countryCode: String) {
        setValue(countryCode,
                 forKey: UserDefaults.Keys.defaultCountryCode.rawValue)
    }
    
    func fetchIsLoggedIn() -> Bool {
        bool(forKey: UserDefaults.Keys.isLoggedIn.rawValue)
    }
    
    func saveIsLoggedIn(isLoggedIn: Bool) {
        UserDefaults.standard
            .setValue(isLoggedIn, forKey: UserDefaults.Keys.isLoggedIn.rawValue)
    }
}

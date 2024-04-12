//
//  SignupModels.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

enum Signup {
    
    // MARK: Use cases
    
    enum Countries {
        struct Request {
        }
        
        struct Response {
            let countries: CountryData
            let geolocation: Geolocation
        }
        struct ViewModel {
            let countries: [CountryViewModel]
            let defaultCountryCode: String
        }
    }
    
    enum Save {
        struct Request {
            let email: String
            let password: String
            let country: String
        }
        
        struct Response {}
        struct ViewModel {}
    }
}

struct CountryViewModel: PickerViewData {
    var title: String {
        countryName
    }
    
    let countryName: String
    let countryCode: String
}

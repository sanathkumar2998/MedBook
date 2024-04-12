//
//  LoginModels.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

enum Login {
    
    // MARK: Use cases
    
    enum Verify {
        struct Request {
            let email: String
            let password: String
        }
        struct Response {}
        struct ViewModel {}
    }
}

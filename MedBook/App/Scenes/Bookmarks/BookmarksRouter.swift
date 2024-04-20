//
//  BookmarksRouter.swift
//  MedBook
//
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

class BookmarksRouter {
    private weak var viewController: BookmarksViewController?
    
    init(viewController: BookmarksViewController) {
        self.viewController = viewController
    }
}

extension BookmarksRouter {
    enum Destination {
        case somewhere
    }
    
    func navigate(to destination: Destination) {
    }
    
}


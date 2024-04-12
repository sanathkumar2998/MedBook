//
//  UIStoryboard+Extension.swift
//  MedBook
//
//  Created by Sanath on 08/04/24.
//

import UIKit

extension UIStoryboard {
    static func makeViewController<ViewController>(name: String, identifier: String, bundle: Bundle? = nil) -> ViewController
        where ViewController: UIViewController
    {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        return storyboard.instantiateViewController(identifier: identifier)
    }
}

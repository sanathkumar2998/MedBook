//
//  NibLoadable.swift
//  MedBook
//
//  Created by Sanath on 15/04/24.
//

import UIKit

protocol NibLoadable: AnyObject {
    func loadFromNib()
}

extension NibLoadable where Self: UIView {
    func loadFromNib() {
        guard let view = viewFromNibForClass() else { return }

        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        view.leftAnchor.constraint(equalTo: leftAnchor)
            .isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor)
            .isActive = true
        view.topAnchor.constraint(equalTo: topAnchor)
            .isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor)
            .isActive = true
    }

    func viewFromNibForClass() -> UIView? {
        let nib = UINib(nibName: String(describing: type(of: self)),
                        bundle: Bundle.main)
        return nib.instantiate(withOwner: self,
                               options: nil).first as? UIView
    }
}

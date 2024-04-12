//
//  TextField.swift
//  MedBook
//
//  Created by Sanath on 10/04/24.
//

import UIKit

/// Custom TextField with the ability to show an error message below it.
class TextField: UITextField {
    private var errorLabel: UILabel?
    
    var errorText: String = "" {
        didSet {
            updateErrorLabel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
}

// MARK: - Private methods

private extension TextField {
    func setup() {
        setupErrorLabel()
    }
    
    func setupErrorLabel() {
        errorLabel = UILabel()
        guard let errorLabel else { return }
        
        addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        errorLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 4).isActive = true
        
        errorLabel.sizeToFit()
        
        errorLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        errorLabel.textColor = .red
    }
    
    func updateErrorLabel() {
        if errorText.isEmpty {
            errorLabel?.text = errorText
            errorLabel?.isHidden = true
            layer.borderColor = UIColor.black.cgColor
            layer.borderWidth = 0
        } else {
            errorLabel?.text = errorText
            errorLabel?.isHidden = false
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 1
        }
    }
}

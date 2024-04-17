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
    private var showPasswordButton: UIButton?
    
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
    
    func enableShowPasswordButton() {
        setupShowPasswordButton()
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
    
    func setupShowPasswordButton() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        containerView.addSubview(button)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        button.tintColor = .black
        rightView = containerView
        rightViewMode = .always
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        showPasswordButton = button
    }
    
    @objc func togglePasswordVisibility() {
        showPasswordButton?.isSelected.toggle()
        isSecureTextEntry.toggle()
        
        if let existingText = text,
           isSecureTextEntry {
            deleteBackward()
            
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
            
            if let existingSelectedTextRange = selectedTextRange {
                selectedTextRange = nil
                selectedTextRange = existingSelectedTextRange
            }
        }
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

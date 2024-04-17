//
//  CheckboxWithTitle.swift
//  MedBook
//
//  Created by Sanath on 15/04/24.
//

import UIKit

class CheckboxWithTitle: UIView, NibLoadable {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setChecked(checked: Bool) {
        if checked {
            imageView.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            imageView.image = UIImage(systemName: "square")
        }
    }
}

// MARK: - Private methods

private extension CheckboxWithTitle {
    func setup() {
        loadFromNib()
    }
}

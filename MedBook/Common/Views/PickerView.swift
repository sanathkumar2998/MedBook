//
//  PickerView.swift
//  MedBook
//
//  Created by Sanath on 11/04/24.
//

import UIKit

protocol PickerViewData {
    var title: String { get }
}

protocol PickerViewDelegate: AnyObject {
    func pickerView(_ pickerView: PickerView, didSelectData data: String)
}

/// Custom Picker to pick one item from array
class PickerView: UIPickerView {

    weak var pickerViewDelegate: PickerViewDelegate?
    var dataArray: [PickerViewData] = [] {
        didSet {
            reloadComponent(0)
        }
    }
        
    func selectTitle(title: String) {
        let titleIndex = dataArray.firstIndex { $0.title == title }
        guard let index = titleIndex else { return }
        selectRow(index, inComponent: 0, animated: true)
        pickerViewDelegate?.pickerView(self, didSelectData: title)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        delegate = self
        //backgroundColor = ColorAsset.color238196.uiColor
    }
}

// MARK: - UIPickerViewDataSource

extension PickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { dataArray.count }
}

// MARK: - UIPickerViewDataSource

extension PickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        NSAttributedString(string: dataArray[row].title,
                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,
                                        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Normal", size: 14) ?? .systemFont(ofSize: 14)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedData = dataArray[row].title
        
        pickerViewDelegate?.pickerView(self, didSelectData: selectedData)
    }
}


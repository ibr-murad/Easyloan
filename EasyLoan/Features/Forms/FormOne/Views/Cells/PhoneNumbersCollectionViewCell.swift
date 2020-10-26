//
//  PhoneNumbersCollectionViewCell.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/26/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class PhoneNumbersCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Variables
    
    static let reuseIdentifier = "PhoneNumbersCollectionViewCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var phoneTextField: UITextField! {
        didSet {
            self.phoneTextField.delegate = self
            self.phoneTextField.keyboardType = .decimalPad
        }
    }
    
    // MARKL - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initCell(text: String) {
        self.phoneTextField.text = text
    }
    
}


  //*****************************//
 // MARK: - UITextFieldDelegate //
//*****************************//

extension PhoneNumbersCollectionViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let formatedString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formatedString.phoneFormater(with: "XXXXXXXXX")
        return false
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
    }
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.layer.borderWidth = 0
    }
}

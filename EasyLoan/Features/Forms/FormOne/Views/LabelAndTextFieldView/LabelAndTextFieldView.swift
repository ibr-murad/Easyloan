//
//  LabelAndTextFieldView.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/22/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

@IBDesignable
class LabelAndTextFieldView: UIView {
    
    // MARK: - Public Variables
    
    var didEndEditingHendler: (() -> Void)?
    
    @IBInspectable
    var title: String = "Title"
    
    @IBInspectable
    var localizedKey: String? {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable
    var placeholder: String = "none" {
        didSet {
            self.textField.placeholder = self.placeholder
        }
    }
    
    @IBInspectable
    var isDecimalKeyboardType: Bool = false {
        didSet {
           self.textField.keyboardType = self.isDecimalKeyboardType ? .decimalPad : .default
        }
    }
    
    @IBInspectable
    var isTextFieldEnabled: Bool = true {
        didSet {
            self.textField.isEnabled = self.isTextFieldEnabled
        }
    }
    
    var validateType: ValidateType = .none
    var isValidate: Bool = false
    
    // MARK: - Enums
    
    enum ValidateType {
        case name
        case email
        case phone
        case none
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: FocusedTextField! {
        didSet {
            self.textField.delegate = self
            self.textField.addTarget(self, action: #selector(self.textFieldEditingChanges), for: .editingChanged)
        }
    }
    
    // MARKL - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: .languageChanged, object: nil)
    }
    
    // MARK: - Helpers
    
    @objc func updateUI() {
        if let string = self.localizedKey {
            self.label.text = string.localized()
        }
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LabelAndTextFieldView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
}

extension LabelAndTextFieldView: UITextFieldDelegate {
    
    @objc func textFieldEditingChanges(_ sender: UITextField) {
        if let text = sender.text {
            switch self.validateType {
            case .email:
                self.isValidate = self.isValidateEmail(email: text)
                break
            case .name:
                self.isValidate = self.isValidateFullName(name: text)
                break
            case .phone:
                self.isValidate = self.isValidatePhone(phone: text)
                break
            case .none:
                self.isValidate = true
                break
            }
            
        }
        self.textField.layer.borderColor = self.isValidate ? UIColor.gray.cgColor : UIColor.red.cgColor
        self.didEndEditingHendler?()
        self.layoutIfNeeded()
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textField.layer.cornerRadius = 5
        self.textField.layer.borderColor = self.isValidate || self.validateType == .none
            ? UIColor.gray.cgColor : UIColor.red.cgColor
        self.textField.layer.borderWidth = 1
        self.layoutIfNeeded()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.textField.layer.borderWidth = 0
        self.textField.clipsToBounds = true
        self.layoutIfNeeded()
    }

    func isValidateEmail(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: email)
    }
    
    func isValidateFullName(name: String) -> Bool {
        let regex = "[A-Za-z]{2,64}+ [A-Za-z]{2,64}+ [A-Za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: name)
    }
    
    func isValidatePhone(phone: String) -> Bool {
        let regex = "[0-9]{9}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: phone)
    }
}

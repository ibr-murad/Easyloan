//
//  UnderlinedButton.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/30/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

@IBDesignable
class UnderlinedButton: UIButton {
    
    // MARK: - variables
    
    var buttonAtributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15),
        .underlineStyle: 1.0]
    
    @IBInspectable
    var textColor: UIColor = .black {
        didSet {
            self.buttonAtributes[.foregroundColor] = self.textColor
        }
    }
    
    @IBInspectable
    var localizedKey: String? {
        didSet {
            self.updateUI()
        }
    }
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI),
                                               name: .languageChanged, object: nil)
    }
    
    // MARK: - Helpers
    
    @objc func updateUI() {
        if let key = self.localizedKey, let text = key.localized() {
            self.setAttributedTitle(NSAttributedString(
                string: text,
                attributes: self.buttonAtributes), for: .normal)
        }
    }
}

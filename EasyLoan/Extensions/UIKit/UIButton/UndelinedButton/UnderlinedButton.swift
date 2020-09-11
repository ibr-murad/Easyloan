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
        .font: UIFont.systemFont(ofSize: 14),
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    @IBInspectable
    var textColor: UIColor = .black {
        didSet {
            self.buttonAtributes[.foregroundColor] = self.textColor
        }
    }
    
    @IBInspectable
    var text: String = "text here" {
        didSet {
            self.setAttributedTitle(
                NSAttributedString(string: self.text,
                                   attributes: self.buttonAtributes), for: .normal)
        }
    }
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

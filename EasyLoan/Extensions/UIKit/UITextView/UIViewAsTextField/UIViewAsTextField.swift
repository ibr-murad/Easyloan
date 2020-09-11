//
//  UIViewAsTextField.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/27/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

@IBDesignable
class UIViewAsTextField: UITextView {
    
    @IBInspectable var isRounded: Bool = false {
        didSet {
            if self.isRounded {
                self.layer.cornerRadius = 5
            } else {
                self.layer.cornerRadius = 0
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = .gray {
        didSet {
            self.layer.borderColor = self.borderColor.withAlphaComponent(0.5).cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.5 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

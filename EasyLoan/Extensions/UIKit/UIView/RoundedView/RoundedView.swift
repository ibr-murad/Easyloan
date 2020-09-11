//
//  RoundView.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/23/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable var isRounded: Bool = false {
        didSet {
            if self.isRounded {
                self.layer.cornerRadius = self.layer.frame.height/2
            } else {
                self.layer.cornerRadius = 0
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForInterfaceBuilder() {}
}

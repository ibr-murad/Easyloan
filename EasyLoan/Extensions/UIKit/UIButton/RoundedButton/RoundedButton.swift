//
//  RoundButton.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/23/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            self.refreshCorners(value: self.cornerRadius)
        }
    }
    
    @IBInspectable var image: UIImage? {
        didSet {
            self.setImage(self.image, for: .normal)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        self.sharedInit()
    }
    
    private func sharedInit() {
        self.setTitle("", for: .normal)
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = AppColors.dark.color().cgColor
        self.refreshCorners(value: self.cornerRadius)
    }
    
    private func refreshCorners(value: CGFloat) {
        self.layer.cornerRadius = value
    }
}

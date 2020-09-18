//
//  RoundedTextButton.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/3/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedTextButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable var localizedKey: String? {
        didSet {
            self.updateUI()
        }
    }
    
    // MARKL - Initialization
    
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
        if let string = self.localizedKey {
            self.setTitle(string.localized(), for: .normal)
        }
    }
}

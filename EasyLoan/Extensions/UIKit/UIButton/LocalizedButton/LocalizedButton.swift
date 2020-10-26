//
//  LocalizedButton.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 9/8/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

@IBDesignable
class LocalizedButton: UIButton {
    
    // MARK: - Public Variables
    
    @IBInspectable
    var localizedKey: String? {
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: .languageChanged, object: nil)
    }
    
    // MARK: - Helpers
    
    @objc func updateUI() {
        if let string = self.localizedKey {
            self.setTitle(string.localized(), for: .normal)
        }
    }
}

//
//  UISearchBar+Ex.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/13/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    func setTextColor(color: UIColor) {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    func setPlaceholder(color: UIColor, text: String ) {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder =
            NSAttributedString(string: " \(text)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    func setSearchField(color: UIColor, cornerRadius: CGFloat) {
        if let textField = self.value(forKey: "searchField") as? UITextField {
            if let backgroundView = textField.subviews.first {
                backgroundView.backgroundColor = color
                
                backgroundView.layer.cornerRadius = cornerRadius
                backgroundView.clipsToBounds = true
            }
        }
    }
}

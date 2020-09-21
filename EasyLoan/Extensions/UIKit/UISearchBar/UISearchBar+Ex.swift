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
    
    func setPlaceholder(color: UIColor, text: String? ) {
        guard let text = text else { return }
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
        
        if let clearCgImage = UIImage(named: "clearIcon")?.cgImage,
            let searchCgImage = UIImage(named: "searchIcon")?.cgImage {
            
            let clearImage = ImageWithoutRender(cgImage: clearCgImage, scale: 6, orientation: .up)
            let searchImage = ImageWithoutRender(cgImage: searchCgImage, scale: 6, orientation: .up)
            
            self.setImage(searchImage, for: .search, state: .normal)
            self.setImage(clearImage, for: .clear, state: .normal)
        }
    }
}

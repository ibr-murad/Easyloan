//
//  String+Ex.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/18/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

extension String {
    
    func phoneFormater(with mask: String) -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for char in mask where index < numbers.endIndex {
            if char == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    func disableFormater(regex: String) -> String {
        return self.replacingOccurrences(of: regex , with: "", options: .literal)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func localized() -> String? {
        var language = "ru"
        
        if let selectedLanguage = UserDefaults.standard.string(forKey: "appLanguage") {
            language = selectedLanguage
        }
        
        return NSLocalizedString(self, tableName: language, comment: "")
    }
}

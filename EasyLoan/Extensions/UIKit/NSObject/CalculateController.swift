//
//  CalculateController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/29/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class CalculateController: NSObject {
    
    var calculateItem: CalculateItem!
    
    func calculateUpdate(buttonSelected: RoundedButton) -> String {
        switch buttonSelected {
        case self.calculateItem.plusButton:
            self.calculateItem.value += 1
            break
        case self.calculateItem.minusButton:
            if self.calculateItem.value > self.calculateItem.minValue {
                self.calculateItem.value -= 1
            }
            break
        default:
            break
        }
        return "\(self.calculateItem.value)"
    }
}

struct CalculateItem {
    var minusButton: RoundedButton
    var plusButton: RoundedButton
    var value: Int
    var minValue: Int
}

//
//  RadionButtonController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/29/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

struct RadioButton {
    var button: RoundedButton
    var value: String
}

import UIKit

class RadioButtonController: NSObject {
    
    var buttonsArray: [RadioButton]! {
        didSet {
            for i in self.buttonsArray {
                i.button.setImage(nil, for: .normal)
                i.button.setImage(UIImage(named: "radioCheckIcon"), for: .selected)
                i.button.adjustsImageWhenHighlighted = false
            }
        }
    }
    var selectedButton: RadioButton?
    
    var defaultButton: RadioButton? {
        didSet {
            guard let defaultButton = self.defaultButton else { return }
            self.buttonArrayUpdated(buttonSelected: defaultButton.button)
        }
    }
    
    func buttonArrayUpdated(buttonSelected: RoundedButton) {
        for button in self.buttonsArray {
            if button.button == buttonSelected {
                self.selectedButton = button
                button.button.isSelected = true
            } else {
                button.button.isSelected = false
            }
        }
    }
    
    func setSelectedByValue(value: String) {
        for button in self.buttonsArray {
            if button.value == value {
                self.buttonArrayUpdated(buttonSelected: button.button)
            }
        }
    }
}

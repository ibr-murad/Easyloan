//
//  UIButton+Ex.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/4/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

extension UIButton {
    
    //MARK:- Animate check mark
    
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
    }
}

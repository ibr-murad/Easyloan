//
//  AppColors.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 9/17/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

enum AppColors {
    case orange
    case green
    case darkBlue
    case dark
    case red
    
    func color() -> UIColor {
        switch self {
        case .orange:
            return UIColor(red: 251/255, green: 134/255, blue: 90/255, alpha: 1)
        case .green:
            return UIColor(red: 83/255, green: 175/255, blue: 126/255, alpha: 1)
        case .darkBlue:
            return UIColor(red: 52/255, green: 70/255, blue: 126/255, alpha: 1)
        case .dark:
            return UIColor(red: 78/255, green: 75/255, blue: 75/255, alpha: 1)
        case .red:
            return UIColor(red: 244/255, green: 23/255, blue: 32/255, alpha: 1)
        }
    }
}

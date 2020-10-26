//
//  MainBaseViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/28/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - variables
    
    var navigationTitle: String? {
        get {
            return self.navigationItem.title
        }
        set {
            self.navigationItem.title = newValue
        }
    }
    
    // MARK: - view life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - setters
    
    private func initController() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupNavBar(style: UIBarStyle, backgroungColor: UIColor, tintColor: UIColor) {
        let attr = [NSAttributedString.Key.foregroundColor: tintColor]
        self.navigationController?.navigationBar.titleTextAttributes = attr
        self.navigationController?.navigationBar.tintColor = tintColor
        self.navigationController?.navigationBar.barTintColor = backgroungColor
        self.navigationController?.navigationBar.barStyle = style
        switch style {
        case .black:
            AppDelegate.shared.rootViewController.setStatusBarStyle(style: .light)
            break
        case .default:
            AppDelegate.shared.rootViewController.setStatusBarStyle(style: .black)
            break
        default:
            break
        }
    }
}

extension BaseViewController {
    func setLeftAlignedNavigationItemTitle(text: String, font: UIFont, color: UIColor, margin left: CGFloat) {
        
        let label = UILabel()
        label.text = text
        label.font = font
        label.textAlignment = .left
        label.textColor = color
        label.sizeToFit()
        
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: label)
    }
}

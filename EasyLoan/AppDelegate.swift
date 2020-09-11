//
//  AppDelegate.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/22/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { return false }
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        DropDown.startListeningToKeyboard()
        
        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: RootViewController {
        return self.window!.rootViewController as! RootViewController
    }
}

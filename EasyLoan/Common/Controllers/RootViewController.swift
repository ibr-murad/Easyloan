//
//  RootViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/7/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.isBlackStatusBar {
            return .default
        }
        return .lightContent
    }
    
    // MARK: - Private Variables
    
    private var isBlackStatusBar: Bool = false
    private var current: UIViewController
    
    // MARK: - Enums
    
    enum StatusBarStyle {
        case black
        case light
    }
    
    // MARK: - Initialization
    
    init() {
        self.current = SplashViewController.instantiate()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.addChild(current)
        self.current.view.frame = view.bounds
        self.view.addSubview(current.view)
        self.current.didMove(toParent: self)
    }
    
    // MARK: - helpers
    
    func showLoginScreen() {
        let new = UINavigationController(rootViewController: AuthorizationViewController())
        self.addChild(new)
        new.view.frame = view.bounds
        self.view.addSubview(new.view)
        new.didMove(toParent: self)
        self.current.willMove(toParent: nil)
        self.current.view.removeFromSuperview()
        self.current.removeFromParent()
        self.current = new
    }
    
    func switchToMainScreen() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else { return }
        self.animateFadeTransition(to: navigationController)
    }
    
    func switchToLogout() {
        let logoutScreen = UIStoryboard.init(name: "Authorization", bundle: nil).instantiateInitialViewController() as? UINavigationController
        self.animateDismissTransition(to: logoutScreen!)
    }
    
    // MARK: - animation
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        self.current.willMove(toParent: nil)
        self.addChild(new)
        self.transition(from: current, to: new, duration: 0.5, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        new.view.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.current.willMove(toParent: nil)
        self.addChild(new)
        self.transition(from: current, to: new, duration: 0.5, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    func setStatusBarStyle(style: StatusBarStyle) {
        switch style {
        case .black:
            self.isBlackStatusBar = true
            break
        case .light:
            self.isBlackStatusBar = false
            break
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

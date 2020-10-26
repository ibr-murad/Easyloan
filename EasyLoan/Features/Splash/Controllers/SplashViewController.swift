//
//  SplashViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/7/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import AVFoundation

class SplashViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Instantiate
    
    static func instantiate() -> SplashViewController {
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "Splash") as? SplashViewController
            else { return SplashViewController()}
        return controller
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeServiceCall()
        
        AVCaptureDevice.requestAccess(for: .video) { (_) in }            
        
    }
     
    // MARK: - Helpers
    
    private func makeServiceCall() {
        self.activityIndicatorViewAnimate(indicator: self.activityIndicator)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.activityIndicator.stopAnimating()
            if UserDefaults.standard.isLoggedIn() {
                AppDelegate.shared.rootViewController.switchToMainScreen()
            } else {
                AppDelegate.shared.rootViewController.switchToLogout()
            }
        }
    }
    
    private func activityIndicatorViewAnimate(indicator: UIActivityIndicatorView) {
        indicator.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.5) {
            indicator.transform = .identity
        }
        indicator.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            indicator.alpha = 1
        }) { (finished) in
            indicator.startAnimating()
        }
    }
}

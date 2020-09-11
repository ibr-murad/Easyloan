//
//  UIViewController+Ex.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/30/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

  //******************//
 // MARK: - Keyboard //
//******************//

extension UIViewController {
    
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

  //***************************//
 // MARK: - Add/remove child  //
//***************************//

extension UIViewController {
    
    func addChildToParent(_ controller: UIViewController, to containerView: UIView? = nil) {
        addChild(controller)
        if let containerView = containerView {
            controller.view.frame = containerView.bounds
            containerView.addSubview(controller.view)
        } else {
            controller.view.frame = view.bounds
            view.addSubview(controller.view)
        }
        controller.didMove(toParent: self)
    }
    
    func removeChildFromParent(_ controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
}

  //*******************************//
 // MARK: - PopoverViewController //
//*******************************//

extension UIViewController: UIPopoverPresentationControllerDelegate {
    
    func presentPopoverViewController(controller: UIViewController,
                                      sourceView: UIView,
                                      size: CGSize, minusY : CGFloat,
                                      arrowDirection: UIPopoverArrowDirection) {
        self.view.endEditing(true)
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = size
        
        let popoverViewController = controller.popoverPresentationController
        popoverViewController?.delegate = self
        popoverViewController?.sourceView = sourceView
        popoverViewController?.sourceRect = CGRect(x: sourceView.bounds.midX,
                                                   y: sourceView.bounds.midY - minusY,
                                                   width: 0, height: 0)
        popoverViewController?.permittedArrowDirections = arrowDirection
        self.navigationController?.present(controller, animated: true)
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

  //*************************//
 // MARK: - AlertController //
//*************************//

extension UIViewController {
    
    func alertError(message: String) {
        let alert = UIAlertController(title: "ERROR".localized(), message: message.capitalizingFirstLetter(), preferredStyle: .alert)
        alert.addAction(.init(title: "Скрыть", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func loadingAlert() {
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        
        if let waitText = "WAIT".localized() {
            alert.message = waitText + "..."
        }
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .gray

        alert.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        present(alert, animated: false, completion: nil)
    }
}

  //*********************//
 // MARK: - Animations  //
//*********************//

extension UIViewController {
    
    func pushWithAnimation(vc: UIViewController, duration: CFTimeInterval, subtype: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = .push
        transition.subtype = subtype
        self.navigationItem.searchController = nil
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func popWithAnimation(vc: UIViewController, duration: CFTimeInterval, subtype: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = .push
        transition.subtype = subtype
        self.navigationItem.searchController = nil
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popToViewController(vc, animated: false)
    }
}

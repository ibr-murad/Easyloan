//
//  AuthorizationViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/23/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import SwiftEntryKit
import IQKeyboardManagerSwift

class AuthorizationViewController: UIViewController {
    
    // MARK: - Private Variables
    
    private let textFieldNumbersLimit = 9
    
    // MARK: - Outlets
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var continueButton: RoundedTextButton!
    @IBOutlet weak var middleStackView: UIStackView!
    @IBOutlet weak var middleViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Instantiate
    
    static func instantiate() -> AuthorizationViewController {
        let storyboard = UIStoryboard(name: "Authorization", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "Authorization") as? AuthorizationViewController
            else { return AuthorizationViewController()}
        return controller
    }
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.shared.rootViewController.setStatusBarStyle(style: .black)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = true
        self.hideKeyboardWhenTappedAround()
        self.setTextFieldIcon()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.phoneTextField.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        self.setEnabledContinueButton(isEnabled: false)
        self.loadingAlert()
        guard let number = self.phoneTextField.text?.disableFormater(regex: " ") else { return }
        Network.shared.request(
            url: URLPath.authOTP + number,
            method: .get,
            success: { [weak self] (token: AuthorizationTokenModel) in
                guard let self = self else { return }
                let controller = AuthorizationSmsViewController.instantiate()
                controller.authToken = token.token
                self.navigationController?.show(controller, sender: nil)
                self.dismiss(animated: true, completion: nil)
        }) { [weak self] (error, code) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                self.alertError(message: error.msg)
            })
            self.setEnabledContinueButton(isEnabled: true)
        }
    }
    
    // MARK: - Helpers
    
    private func setEnabledContinueButton(isEnabled: Bool) {
        self.continueButton.isEnabled = isEnabled
        if isEnabled {
            UIView.animate(withDuration: 0.5) {
                self.continueButton.backgroundColor = AppColors.orange.color()
                self.continueButton.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.continueButton.backgroundColor = .lightGray
                self.continueButton.alpha = 0.5
            }
        }
    }
    
    private func moveMiddleView(_ value: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.middleViewTopConstraint.constant = value
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Setters
    
    private func setTextFieldIcon() {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 24))
        let imageView = UIImageView(frame: CGRect(x: 8, y: 4, width: 24, height: 20))
        imageView.image = UIImage(named: "callBlackIcon")
        leftView.addSubview(imageView)
        self.phoneTextField.leftViewMode = .unlessEditing
        self.phoneTextField.leftView = leftView
    }
}

  //*****************************//
 // MARK: - UITextFieldDelegate //
//*****************************//

extension AuthorizationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let formatedString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formatedString.phoneFormater(with: "XX XXX XX XX")
        let notFormatedText = textField.text?.disableFormater(regex: " ")
        if (notFormatedText?.count ?? 0) < self.textFieldNumbersLimit {
            self.setEnabledContinueButton(isEnabled: false)
        } else {
            self.setEnabledContinueButton(isEnabled: true)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
        self.moveMiddleView(-50)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
        self.moveMiddleView(0)
    }
}

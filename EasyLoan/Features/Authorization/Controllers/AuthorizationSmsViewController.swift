//
//  AuthorizationSmsViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/24/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class AuthorizationSmsViewController: UIViewController {
    
    // MARK: - Public Variables
    
    var authToken: String = ""
    
    // MARK: - Private Variables
    private let textFieldNumbersLimit = 5
    
    // MARK: - Outlets
    
    @IBOutlet weak var middleStackView: UIStackView!
    @IBOutlet weak var middleStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var smsTextField: UITextField!
    @IBOutlet weak var continueButton: RoundedTextButton!    
    
    // MARK: - Instantiate
    
    static func instantiate() -> AuthorizationSmsViewController {
        let storyboard = UIStoryboard(name: "Authorization", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "AuthorizationSms") as? AuthorizationSmsViewController
            else { return AuthorizationSmsViewController() }
        return controller
    }
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.shared.rootViewController.setStatusBarStyle(style: .light)
        self.navigationController?.navigationBar.barStyle = .black
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.smsTextField.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let pass = self.smsTextField.text?.disableFormater(regex: "-") else { return }
        self.loadingAlert()
        Network.shared.request(
            url: URLPath.authOTP, method: .post,
            parameters: ["token": self.authToken, "pass": pass],
            success: { (data: UserModel) in
                UserDefaults.standard.setLoggedInUser(user: data)
                AppDelegate.shared.rootViewController.switchToMainScreen()
                self.dismiss(animated: false, completion: nil)
        }) { (error, code) in
            self.dismiss(animated: true, completion: {
                self.alertError(message: error.msg)
            })
        }
    }
    
    // MARK: - Setters

    private func setEnabledContinueButton(isEnabled: Bool) {
        self.continueButton.isEnabled = isEnabled
        if isEnabled {
            UIView.animate(withDuration: 0.5) {
                if #available(iOS 11.0, *) {
                    self.continueButton.backgroundColor = UIColor(named: "appColor")
                } else {
                    // Fallback on earlier versions
                }
                self.continueButton.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.continueButton.backgroundColor = .lightGray
                self.continueButton.alpha = 0.5
            }
        }
    }
}

  //*****************************//
 // MARK: - UITextFieldDelegate //
//*****************************//

extension AuthorizationSmsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let formatedString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formatedString.phoneFormater(with: "XXXXX")
        let notFormatedText = textField.text?.disableFormater(regex: "")
        if (notFormatedText?.count ?? 0) < self.textFieldNumbersLimit {
            self.setEnabledContinueButton(isEnabled: false)
        } else {
            self.setEnabledContinueButton(isEnabled: true)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.middleStackViewTopConstraint.constant = -50
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.middleStackViewTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}


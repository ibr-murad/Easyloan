//
//  FormFiveViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/28/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import SwiftEntryKit
import Alamofire

class FormFiveViewController: FormsBaseViewController {
    
    // MARK: - Public Variables
    
    override var createdRequestId: Int? {
        didSet {
            self.getRequestFullModel()
        }
    }
    
    override var requestFull: RequestFullViewModel? {
        didSet {
            self.setupLabelsWithRequest()
        }
    }
    
    // MARK: - Instantiate
    
    static func instantiate() -> FormFiveViewController {
        let storyboard = UIStoryboard(name: "FormFive", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "FormFive") as? FormFiveViewController
            else { return FormFiveViewController()}
        return controller
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var loanAmountLabel: UILabel!
    @IBOutlet weak var loanTermLabel: UILabel!
    @IBOutlet weak var sendButton: RoundedTextButton!
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupLabelsWithRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setEnabledSendButton(isEnabled: false)
        self.setIsEditable()
    }
    
    // MARK: - Networking
    
    private func getRequestFullModel() {
        guard let id = self.createdRequestId else { return }
        let url = URLPath.applicationById + String(describing: id)
        Network.shared.request(
            url: url , method: .get,
            headers: ["auth-token": UserDefaults.standard.getUser().token],
            success: { [weak self] (request: RequestFullModel) in
                guard let self = self else { return }
                self.requestFull = RequestFullViewModel(request: request)
                guard let requestFull = self.requestFull else { return }
                let isRequestSync = requestFull.stepFirst && requestFull.stepSecond &&
                    requestFull.stepThird && requestFull.stepFive && requestFull.files.count >= 2
                let isAllFormsFilled = requestFull.stepFirst && requestFull.stepSecond &&
                    requestFull.stepThird && requestFull.files.count >= 2
                if isRequestSync {
                    self.topLabel.text = "REQUEST_SYNC".localized()
                    self.messageLabel.text = " "
                } else if isAllFormsFilled {
                    self.topLabel.text = "REQUEST_FILL".localized()
                    self.messageLabel.text = "REQUEST_FILL_MSG".localized()
                } else {
                    self.topLabel.text = "REQUEST_NOT_FILL".localized()
                    self.messageLabel.text = "REQUEST_NOT_FILL_MSG".localized()
                }
        }) { (error, code) in
        }
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        self.setEnabledSendButton(isEnabled: false)
        guard let request = self.requestFull else { return }
        Network.shared.syncWithCFT(id: String(describing: request.id)) { [weak self] in
            guard let self = self else { return }
            let view = SuccesPopoverView()
            view.okButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.setEnabledSendButton(isEnabled: true)
            SwiftEntryKit.display(entry: view, using: EKAttributes.setupAttributes(statusBar: .light))
        }
    }

    // MARK: - Setters
    
    private func setupLabelsWithRequest() {
        guard let request = self.requestFull else { return }
        self.fullNameLabel.text = request.fullName
        if request.clientPhoneNumber.count > 0 {
            self.phoneNumberLabel.text = request.clientPhoneNumber[0]
        }
        self.emailLabel.text = request.email
        self.loanAmountLabel.text = "\(request.loanAmount) " + self.getCurrencyNameById(id: request.loanCurrency)
        self.loanTermLabel.text = "\(request.loanTerm) месяцев"
        let isAllFormsFilled = request.stepFirst && request.stepSecond &&  request.stepThird
        if isAllFormsFilled && request.files.count >= 2 {
            self.setEnabledSendButton(isEnabled: true)
        } else {
            self.setEnabledSendButton(isEnabled: false)
        }
        if request.stepFive {
            self.setEnabledSendButton(isEnabled: false)
        }
    }
    
    private func setEnabledSendButton(isEnabled: Bool) {
        self.sendButton.isEnabled = isEnabled
        if isEnabled {
            UIView.animate(withDuration: 0.5) {
                self.sendButton.backgroundColor = AppColors.darkBlue.color()
                self.sendButton.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.sendButton.backgroundColor = .lightGray
                self.sendButton.alpha = 0.5
            }
        }
    }
    
    private func setIsEditable() {
        if self.isEditable {
            self.view.isUserInteractionEnabled = true
            self.topLabel.text = "REQUEST_NOT_FILL".localized()
            self.messageLabel.text = "REQUEST_NOT_FILL_MSG".localized()
        } else {
            self.view.isUserInteractionEnabled = false
            self.topLabel.text = "REQUEST_SYNC".localized()
            self.messageLabel.text = " "
        }
    }
    
    // MARK: - Helpers
    
    private func getCurrencyNameById(id: Int) -> String {
        let dicts = UserDefaults.standard.getDictionaryByName(name: .ftMoney)
        var name = ""
        for item in dicts {
            if item.id == id {
                name.append(item.name)
                break
            }
        }
        return name
    }
}

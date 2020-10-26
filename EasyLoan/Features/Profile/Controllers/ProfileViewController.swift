//
//  ProfileViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/22/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import DropDown
import SwiftEntryKit

class ProfileViewController: BaseViewController {
    
    // MARK: - Public Variables
    
    private let userModel: UserModel = UserDefaults.standard.getUser()

    // MARK: - Outlets
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var allRequestsLabel: UILabel!
    @IBOutlet weak var uploadedRequestsLabel: UILabel!
    @IBOutlet weak var approvedRequestsLabel: UILabel!
    @IBOutlet weak var languageView: UIStackView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var apVersionLabel: UILabel!
    
    // MARK: - Instantiate
    
    static func instantiate() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? ProfileViewController
            else { return ProfileViewController() }
        return controller
    }
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadingAlert()
        self.phoneNumberLabel.text = self.userModel.user.phoneNumber
        self.setNavigationBar()
        self.setLanguageLabelText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.requestForData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    // MARK: - Networking
    
    private func requestForData() {
        self.loadingAlert()
        Network.shared.request(
            url: URLPath.application,
            method: .get,
            headers: ["auth-token": UserDefaults.standard.getUser().token],
            success: { [weak self] (requests: [RequestModel]) in
                guard let self = self else { return }
                var uploaded: [RequestModel] = []
                var approved: [RequestModel] = []
                requests.forEach {
                    if $0.state == "UPLOADED" {
                        uploaded.append($0)
                    } else if $0.state == "APPROVED" {
                        approved.append($0)
                    }
                }
                self.allRequestsLabel.text = String(describing: requests.count)
                self.uploadedRequestsLabel.text = String(describing: uploaded.count)
                self.approvedRequestsLabel.text = String(describing: approved.count)
                self.dismiss(animated: true, completion: nil)
                self.view.layoutIfNeeded()
        }) { [weak self] (error, code) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                self.alertError(message: error.msg)
            })
        }
    }
    
    private func logout() {
        Network.shared.delete(
            url: URLPath.logout,
            headers: ["auth-token": UserDefaults.standard.getUser().token],
            success: {
                UserDefaults.standard.setLoggedOutUser()
                AppDelegate.shared.rootViewController.switchToLogout()
        }, feilure: { (error) in
            print(error)
        })
    }
    
    // MARK: - Actions
    
    @IBAction func notificationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            let fcmToken = UserDefaults.standard.getFcmToken()
            Network.shared.sendFcmTokenToAPI(token: fcmToken)
            UserDefaults.standard.set(true, forKey: "isNeedNotifications")
        } else {
            Network.shared.sendFcmTokenToAPI()
            UserDefaults.standard.set(false, forKey: "isNeedNotifications")
        }
    }
    
    @objc private func languageViewTapped() {
        let dropDown = DropDown()
        dropDown.anchorView = self.languageView
        guard let tj = "LANGUAGE_TJ".localized(),
            let ru = "LANGUAGE_RU".localized(),
            let en = "LANGUAGE_EN".localized() else { return }
        
        dropDown.dataSource = [tj, ru, en]
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            if index == 0 {
                UserDefaults.standard.set("tj", forKey: "appLanguage")
                self.setLanguageLabelText()
            }
            if index == 1 {
                UserDefaults.standard.set("ru", forKey: "appLanguage")
                self.setLanguageLabelText()
            }
             if index == 2 {
                UserDefaults.standard.set("en", forKey: "appLanguage")
                self.setLanguageLabelText()
            }
            
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
        dropDown.backgroundColor = .white
        dropDown.width = 150
        dropDown.show()
    }
    
    @IBAction func logoutButtonTapped(_ sender: UnderlinedButton) {
        let logoutAlert = LogoutAlertView()
        logoutAlert.yesButtonTappedHendler = { [weak self] in
            guard let self = self else { return }
            self.logout()
            SwiftEntryKit.dismiss()
        }
        SwiftEntryKit.display(entry: logoutAlert,
                              using: EKAttributes.setupAttributes(statusBar: .dark))
    }
    
    // MARK: - Setters
    
    private func setNavigationBar() {
        self.setupNavBar(style: .default, backgroungColor: .white, tintColor: AppColors.dark.color())
        self.navigationTitle = self.userModel.user.fullName
    }
    
    private func setupViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.languageViewTapped))
        self.languageView.addGestureRecognizer(tap)
        let isNeedNotifications = UserDefaults.standard.isNeedNotifications()
        self.notificationSwitch.isOn = isNeedNotifications
    }
  
    private func setLanguageLabelText() {
        guard let currentLanguage = UserDefaults.standard.value(forKey: "appLanguage") as? String
            else { return }
        if currentLanguage == "tj" {
            self.languageLabel.text = "Тоҷики"
        } else if currentLanguage == "ru" {
            self.languageLabel.text = "Русский"
        } else {
            self.languageLabel.text = "English"
        }
    }
}

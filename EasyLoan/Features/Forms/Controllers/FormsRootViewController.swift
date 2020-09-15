//
//  FormsRootViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/19/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import SwiftEntryKit

class FormsRootViewController: UIViewController {
    
    // MARK: - Public Variables
    
    var isEditable: Bool = true
    var requestId: Int? {
        didSet {
            self.getRequestFullModel()
        }
        
    }
    
    // MARK: - Private Variables
    
    private var requestFull: RequestFullViewModel? {
        didSet {
            self.forms.forEach {
                $0.requestFull = self.requestFull
            }
            self.setPaginationItemCheckImage()
        }
    }
    private var createdRequestId: Int? {
        didSet {
            self.forms.forEach {
                $0.createdRequestId = self.createdRequestId
            }
        }
    }

    private var currentViewController: UIViewController? {
        willSet {
            guard let controller = self.currentViewController as? FormsBaseViewController else { return }
            guard let index = self.forms.firstIndex(of: controller) else { return }
            self.currentControllerIndex = index
        } didSet {
            guard let controller = self.currentViewController as? FormsBaseViewController else { return }
            guard let index = self.forms.firstIndex(of: controller) else { return }
            self.nextControllerIndex = index
            self.startAnimate()
        }
    }
    
    private var currentControllerIndex: Int = 0
    private var nextControllerIndex: Int = 0
    private var isFirstAppear = true
    
    private let formOne = FormOneViewController.instantiate()
    private let formTwo = FormTwoViewController.instantiate()
    private let formThree = FormThreeViewController.instantiate()
    private let formFour = FormFourViewController.instantiate()
    private let formFive = FormFiveViewController.instantiate()
    
    private var forms: [FormsBaseViewController] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var paginationView: PaginationView!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setPaginationViewHandlers()
        self.setControllersContinueButtonTappedHandlers()
        self.setControllersIsFormFullHandlers()
        self.setCompletionHendlers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setForms()
        self.forms.forEach {
            $0.isEditable = self.isEditable
            $0.createdRequestId = self.requestId
        }
        
        self.setNavigationBar()
        self.addChildren()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - Networking
    
    private func getRequestFullModel() {
        guard let id = self.requestId else { return }
        let url = URLPath.applicationById + String(describing: id)
        Network.shared.request(
            url: url , method: .get,
            headers: ["auth-token": UserDefaults.standard.getUser().token],
            success: { [weak self] (request: RequestFullModel) in
                guard let self = self else { return }
                self.requestFull = RequestFullViewModel(request: request)
        }) { [weak self] (error, code) in
            guard let self = self else { return }
            self.alertError(message: error.msg)
        }
    }
    
    private func deleteRequest(id: Int) {
        let url = URLPath.applicationById + String(describing: id)
        Network.shared.delete(url: url, success: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.alertError(message: error.localizedDescription)
        }
    }
    
    // MARK: - Helpers
    
    private func updateCurrentController(controller: UIViewController) {
        for child in self.forms {
            if child === controller {
                self.bringToFront(controller: child)
            }
        }
    }
    
    private func addChildren() {
        self.forms.forEach {
            self.addChildToParent($0, to: self.containerView)
        }
        self.updateCurrentController(controller: self.forms[0])
    }
    
    private func removeChilden() {
        self.forms.forEach {
            self.self.removeChildFromParent($0)
        }
    }
    
    private func bringToFront(controller: UIViewController) {
        if self.currentViewController !== controller {
            self.containerView.bringSubviewToFront(controller.view)
            self.currentViewController?.viewWillDisappear(true)
            self.currentViewController = controller
            self.currentViewController?.viewWillAppear(true)
            self.view.endEditing(true)
        }
    }
    
    private func startAnimate() {
        if !self.isFirstAppear {
            if self.currentControllerIndex < self.nextControllerIndex {
                self.animatePushChild()
            } else if self.currentControllerIndex > self.nextControllerIndex {
                self.animatePopChild()
            }
        } else {
            self.isFirstAppear = false
        }
    }
    
    private func animatePushChild() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .push
        transition.subtype = .fromRight
        self.containerView.layer.add(transition, forKey: nil)
    }
    
    private func animatePopChild() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .push
        transition.subtype = .fromLeft
        self.containerView.layer.add(transition, forKey: nil)
    }
    
    private func showDeleteAlert(id: Int) {
        let alertView = DeleteAlertView()
        alertView.yesButtonTappedHendler = { [weak self, id] in
            guard let self = self else { return }
            self.deleteRequest(id: id)
            SwiftEntryKit.dismiss()
        }
        SwiftEntryKit.display(entry: alertView,
                              using: EKAttributes.setupAttributes(statusBar: .light))
    }
    
    
    // MARK: - Actions
    
    @objc private func deleteBarButtonTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if let id = self.createdRequestId {
            self.showDeleteAlert(id: id)
        } else if let id = self.requestId {
            self.showDeleteAlert(id: id)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Setters
    
    private func setNavigationBar() {
        let emptyBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = emptyBackButton
        if self.isEditable {
            self.navigationItem.title = "NEW_REQUEST".localized()
            self.setNavigationBarDeleteButton()
        } else {
            self.navigationItem.title = "REQUEST".localized()
        }
    }
    
    private func setNavigationBarDeleteButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.deleteBarButtonTapped))
        self.navigationItem.rightBarButtonItem = button
    }
    
    private func setForms() {
        self.forms = [self.formOne, self.formTwo, self.formThree, self.formFour, self.formFive]
    }
    
    private func setPaginationViewHandlers() {
        self.paginationView.stepOneButtonTappedHandler = { [weak self] in
            guard let self = self else { return }
            self.updateCurrentController(controller: self.forms[0])
        }
        self.paginationView.stepTwoButtonTappedHandler = { [weak self] in
            guard let self = self else { return }
            self.updateCurrentController(controller: self.forms[1])
        }
        self.paginationView.stepThreeButtonTappedHandler = { [weak self] in
            guard let self = self else { return }
            self.updateCurrentController(controller: self.forms[2])
        }
        self.paginationView.stepFourButtonTappedHandler = { [weak self] in
            guard let self = self else { return }
            self.updateCurrentController(controller: self.forms[3])
        }
        self.paginationView.stepFiveButtonTappedHandler = { [weak self] in
            guard let self = self else { return }
            self.updateCurrentController(controller: self.forms[4])
        }
    }
    
    private func setControllersContinueButtonTappedHandlers() {
        for i in 0..<self.forms.count {
            if i != 4 {
                let current = self.forms[i]
                let next = self.forms[i + 1]
                current.continueButtonTappedHandler = { [weak self] in
                    guard let self = self else { return }
                    let button = self.paginationView.buttons[i+1]
                    self.paginationView.updateSelectedButton(buttonSelected: button)
                    self.updateCurrentController(controller: next)
                }
            }
        }
    }
    
    private func setCompletionHendlers() {
        for i in 0..<self.forms.count {
            if i != 4 {
                let current = self.forms[i]
                let next = self.forms[i + 1]
                current.completionHendler = { [weak self] id, familyNumber in
                    guard let self = self else { return }
                    if i == 0 {
                        if let familyNumber = familyNumber {
                            next.familyMemberNum = familyNumber
                        }
                    }
                    self.createdRequestId = id
                }
            }
        }
    }
    
    private func setControllersIsFormFullHandlers() {
        for i in 0..<self.forms.count {
            self.forms[i].isFormFullHandler = { [weak self] isFull in
                guard let self = self else { return }
                let button = self.paginationView.buttons[i]
                if isFull {
                    guard let image = UIImage(named: "statusApproved") else { return }
                    button.setBackgroundImage(image, for: .normal)
                } else {
                    button.setBackgroundImage(UIImage(), for: .normal)
                }
            }
        }
    }
    
    private func setPaginationItemCheckImage() {
        guard let request = self.requestFull else { return }
        guard let buttons = self.paginationView.buttons else { return }
        guard let image = UIImage(named: "statusApproved") else { return }
        let step1 = request.stepFirst
        let step2 = request.stepSecond
        let step3 = request.stepThird
        let step4 = request.files.count >= 2
        let step5 = request.stepFive
        if step1 {
            buttons[0].setBackgroundImage(image, for: .normal)
        }
        if step2 {
            buttons[1].setBackgroundImage(image, for: .normal)
        }
        if step3 {
            buttons[2].setBackgroundImage(image, for: .normal)
        }
        if step4 {
            buttons[3].setBackgroundImage(image, for: .normal)
        }
        if step5 {
            buttons[4].setBackgroundImage(image, for: .normal)
        }
    }
    
    private func setPaginationViewItemImage(_ value: Bool, for step: Int) {
        let button = self.paginationView.buttons[step]
        if value {
            button.image = UIImage(named: "statusApproved")
        } else {
            button.image = UIImage()
        }
    }
    
}

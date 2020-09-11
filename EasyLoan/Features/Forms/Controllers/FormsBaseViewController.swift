//
//  FormsBaseViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/20/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class FormsBaseViewController: UIViewController {
    
    // MARK: - Public Variables
    
    var requestFull: RequestFullViewModel?
    var createdRequestId: Int?
    var familyMemberNum: Int = 1
    var isEditable: Bool = true
    var isFormFullHandler: ((Bool) -> Void)?
    var continueButtonTappedHandler: (() -> Void)?
    var completionHendler: ((Int, Int?) -> Void)?
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
}

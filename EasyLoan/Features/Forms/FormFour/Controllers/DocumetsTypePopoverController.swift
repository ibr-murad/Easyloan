//
//  DucumetTypePopoverController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/18/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class DocumetsTypePopoverController: UIViewController {
    
    // MARK: - Public Variables
    
    var selectedDocumentValueHendler: ((String) -> Void)?
    
    // MARK: - Private Variables
    
    private let photoTypes = ["PAS", "TIN", "INC", "APP", "PHO", "OTH"]
    
    // MARK: - Instantiate
    
    static func instantiate() -> DocumetsTypePopoverController {
        let storyboard = UIStoryboard(name: "FormFour", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "Documents") as? DocumetsTypePopoverController
            else { return DocumetsTypePopoverController() }
        return controller
    }    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    @IBAction private func firstButtonTapped(_ sender: UIButton) {
        self.selectedDocumentValueHendler?(self.photoTypes[0])
    }
    @IBAction private func secondButtonTapped(_ sender: UIButton) {
        self.selectedDocumentValueHendler?(self.photoTypes[1])
    }
    @IBAction private func thirdButtonTapped(_ sender: UIButton) {
        self.selectedDocumentValueHendler?(self.photoTypes[2])
    }
    @IBAction private func fourthButtonTapped(_ sender: UIButton) {
        self.selectedDocumentValueHendler?(self.photoTypes[3])
    }
    @IBAction private func fifthButtonTapped(_ sender: UIButton) {
        self.selectedDocumentValueHendler?(self.photoTypes[4])
    }
    @IBAction private func sixthButtonTapped(_ sender: UIButton) {
        self.selectedDocumentValueHendler?(self.photoTypes[5])
    }

}

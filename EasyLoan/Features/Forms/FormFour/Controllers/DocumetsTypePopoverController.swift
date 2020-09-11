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
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstLabel: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.firstLabelTapped))
            self.firstLabel.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var socondLabel: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.socondLabelTapped))
            self.socondLabel.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var thirdLabel: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.thirdLabelTapped))
            self.thirdLabel.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var fourthLabel: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.fourthLabelTapped))
            self.fourthLabel.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var fifthLabel: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.fifthLabelTapped))
            self.fifthLabel.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var sixthLabel: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.sixthLabelTapped))
            self.sixthLabel.addGestureRecognizer(tap)
        }
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @objc private func firstLabelTapped() {
        self.selectedDocumentValueHendler?(self.photoTypes[0])
    }
    @objc private func socondLabelTapped() {
        self.selectedDocumentValueHendler?(self.photoTypes[1])
    }
    @objc private func thirdLabelTapped() {
        self.selectedDocumentValueHendler?(self.photoTypes[2])
    }
    @objc private func fourthLabelTapped() {
        self.selectedDocumentValueHendler?(self.photoTypes[3])
    }
    @objc private func fifthLabelTapped() {
        self.selectedDocumentValueHendler?(self.photoTypes[4])
    }
    @objc private func sixthLabelTapped() {
        self.selectedDocumentValueHendler?(self.photoTypes[5])
    }
}

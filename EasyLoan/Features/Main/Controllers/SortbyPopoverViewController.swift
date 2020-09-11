//
//  SortbyPopoverViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/14/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class SortbyPopoverViewController: UIViewController {
    
    // MARK: - Public Variables
    
    var currentValue: ((RequestsOrderBy) -> Void)?
    
    // MARK: - Instantiate
    
    static func instantiate() -> SortbyPopoverViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "Sortby") as? SortbyPopoverViewController
            else { return SortbyPopoverViewController()}
        return controller
    }
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    @IBAction func orderByDateButtonTapped(_ sender: Any) {
        self.currentValue?(.date)
    }
    @IBAction func orderByNameButtonTapped(_ sender: Any) {
        self.currentValue?(.name)
    }
    @IBAction func orderByApprovedButtonTapped(_ sender: Any) {
        self.currentValue?(.approved)
    }
    @IBAction func orderByRejectedButtonTapped(_ sender: Any) {
        self.currentValue?(.rejected)
    }
    @IBAction func orderByDraftButtonTapped(_ sender: Any) {
        self.currentValue?(.draft)
    }
    @IBAction func orderByUploadedButtonTapped(_ sender: Any) {
        self.currentValue?(.uploaded)
    }
    @IBAction func orderByRevisionButtonTapped(_ sender: Any) {
        self.currentValue?(.revision)
    }
    
}

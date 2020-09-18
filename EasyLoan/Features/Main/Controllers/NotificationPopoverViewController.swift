//
//  NotificationPopoverTableViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/13/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class NotificationPopoverViewController: UIViewController {
    
    // MARK: - variables
    
    var isNeedFullData: Bool = false
    var showAllButtonTappedClosure: (() -> Void)?
    
    private var data: [RequestModel] = []
    // MARK: - instantiate
    
    static func instantiate() -> NotificationPopoverViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "Notification") as? NotificationPopoverViewController
            else { return NotificationPopoverViewController()}
        return controller
    }
    
    // MARK: - outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func showAllButtonTapped(_ sender: Any) {
        self.showAllButtonTappedClosure?()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NotificationPopoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isNeedFullData {
            tableView.isScrollEnabled = true
            return self.data.count
        } else {
            tableView.isScrollEnabled = false
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        //let model = self.data[indexPath.row]
        return cell
    }
}

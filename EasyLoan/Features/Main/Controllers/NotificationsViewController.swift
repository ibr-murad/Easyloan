//
//  NotificationPopoverTableViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/13/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import Alamofire

class NotificationsViewController: UIViewController {
    
    private var notifications: [NotificationViewModel] = []
    
    // MARK: - instantiate
    
    static func instantiate() -> NotificationsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "Notification") as? NotificationsViewController
            else { return NotificationsViewController()}
        return controller
    }
    
    // MARK: - outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "NOTIFICATION".localized()
        self.tableView.tableFooterView = UIView()
        self.requestForNotifications()
    }
    
    // MARK: - Networking
    
    private func requestForNotifications() {
        Network.shared.request(
            url: URLPath.getNotifications,
            method: .get,
            parameters: ["offSet": 0, "limit": 20],
            headers: ["auth-token": UserDefaults.standard.getUser().token],
            isQueryString: true,
            success: { [weak self] (notifications: [NotificationModel]) in
                guard let self = self else { return }
                notifications.forEach {
                    self.notifications.append(.init(model: $0))
                }
                self.tableView.reloadData()
        }) { (error, _) in
            print(error.msg)
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        let model = self.notifications[indexPath.row]
        
        (cell as? NotificationTableViewCell)?
            .initView(statusImage: model.stateImage, title: model.title,
                      description: model.text, date: model.createdAt)
        return cell
    }
}

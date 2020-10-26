//
//  MainTableViewControllerr.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/22/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import SwiftEntryKit
import IQKeyboardManagerSwift

class MainViewController: BaseViewController {

    // MARK: - GUI Variables
        
    private lazy var searchController: UISearchController = {
        var controller = UISearchController(searchResultsController: nil)
        if #available(iOS 9.1, *) {
            controller.obscuresBackgroundDuringPresentation = false
        }
        var searchBar = controller.searchBar
        searchBar.delegate = self
        searchBar.barStyle = .default
        searchBar.tintColor = .white
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.leftView?.tintColor = .black
            searchBar.searchTextField.rightView?.tintColor = .black
            searchBar.searchTextField.backgroundColor = .white
            searchBar.searchTextField.subviews[0].subviews[0].removeFromSuperview()
        } else {
            searchBar.setSearchField(color: .white, cornerRadius: 12)
            searchBar.backgroundColor = AppColors.orange.color()
            searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        }
        searchBar.setTextColor(color: AppColors.dark.color())
        return controller
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlListener), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Private Variables
    
    private var data: [RequestViewModel] = []
    private var filteredData: [RequestViewModel] = []
    private var isFiltering: Bool = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundTitleLabel: UILabel!
    @IBOutlet weak var backgroundDescriptionLabel: UILabel!
    @IBOutlet weak var retryButton: LocalizedButton!
    @IBOutlet weak var bottomTabView: UIView!
    @IBOutlet weak var newRequestButton: RoundedButton!
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = false
        self.loadingAlert()
        self.backgroundDescriptionLabel.text = "YOUR_FUTURE_REQUESTS_LIST".localized()
        self.retryButton.isEnabled = false
        self.retryButton.isHidden = true
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.requestForData {
            self.reloadControllerData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestForDictinaryList()
        self.setTableView()
        self.setSearchViewController()
        self.setBottomTabView()
        self.reloadControllerData()
    }
    
    // MARK: - Actions
    
    @IBAction func statisticsTabButtonTapped(_ sender: UIButton) {
        self.navigationController?
            .pushViewController(StatisticsViewController.instantiate(), animated: true)
    }
    
    @IBAction func profileTabButtonTapped(_ sender: UIButton) {
        self.navigationController?
            .pushViewController(ProfileViewController.instantiate(), animated: true)
    }
    
    @IBAction func newRequestTapped(_ sender: RoundedButton) {
        guard let controller = UIStoryboard.init(name: "Forms", bundle: nil)
            .instantiateInitialViewController() else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func filterBarButtonTapped(_ sender: UIBarButtonItem) {
        let controller = SortbyPopoverViewController.instantiate()
        
        controller.currentValue = { [weak self] value in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            self.requestForData(value) {
                self.reloadControllerData()
            }
            if let str1 = "YOU_HAVE_NOT_REQUESTS".localized() {
                if value == .date || value == .name {
                    self.backgroundDescriptionLabel.text = "\(str1)"
                } else {
                    if let str2 = "WITH_STATUS".localized(),
                        let str3 = value.getLocalized() {
                        self.backgroundDescriptionLabel.text = "\(str1) \(str2) \"\(str3)\""
                    }
                }
            }
        }
        
        self.presentPopoverViewController(
            controller: controller,
            sourceView: self.view,
            size: CGSize(width: 300, height: 360),
            minusY: 70, arrowDirection: UIPopoverArrowDirection(rawValue: 0))
    }
    
    @IBAction func notificationBarButtonTapped(_ sender: UIBarButtonItem) {
        let controller = NotificationsViewController.instantiate()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func retryButtonTapped(_ sender: LocalizedButton) {
        sender.isHidden = true
        sender.isEnabled = false
        self.loadingAlert()
        self.requestForData {
            self.reloadControllerData()
        }
    }
    
    
    @objc private func refreshControlListener(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        self.requestForData {
            sender.endRefreshing()
            self.reloadControllerData()
        }
    }
    
    // MARK: - Setters
    
    private func setNavigationBar() {
        self.setLeftAlignedNavigationItemTitle(
            text: "EasyLoan", font: .boldSystemFont(ofSize: 20),
            color: .white, margin: 10)
        self.setupNavBar(style: .black, backgroungColor: AppColors.orange.color(), tintColor: .white)
        self.searchController.searchBar
            .setPlaceholder(color: .lightGray, text: "SEARCH".localized())
    }
    
    private func setTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 78
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior =
                UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
    }
    
    private func setSearchViewController() {
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = self.searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            self.tableView.tableHeaderView = self.searchController.searchBar
            self.tableView.tableHeaderView?.backgroundColor = AppColors.orange.color()
            self.searchController.hidesNavigationBarDuringPresentation = false
            self.extendedLayoutIncludesOpaqueBars = true
        }
    }
    
    private func setBackgroundViewVisible(value: Bool) {
        if value {
            self.backgroundTitleLabel.text = "REQUESTS_LIST".localized()
            UIView.animate(withDuration: 0.5) {
                self.backgroundView.alpha = 1
                self.tableView.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.backgroundView.alpha = 0
                self.tableView.alpha = 1
            }
        }
    }
    
    private func setBottomTabView() {
        self.bottomTabView.layer.masksToBounds = true
        self.bottomTabView.layer.shadowOpacity = 0.2
        self.bottomTabView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.bottomTabView.layer.shadowColor = UIColor.black.cgColor
        self.bottomTabView.layer.masksToBounds = false
    }
    
    // MARK: - Networking
    
    private func requestForData(_ order: RequestsOrderBy = .date, completion: @escaping () -> Void) {
        self.data = []
        self.filteredData = []
        self.reloadControllerData()
        self.isFiltering = false
        self.searchController.isActive = false
        Network.shared.request(
            url: URLPath.application,
            method: .get,
            parameters: ["order": order.rawValue],
            headers: ["auth-token": UserDefaults.standard.getUser().token],
            isQueryString: true,
            success: { [weak self] (requests: [RequestModel]) in
                guard let self = self else { return }
                requests.forEach {
                    self.data.append(.init(model: $0))
                }
                self.dismiss(animated: true, completion: nil)
                self.newRequestButton.isEnabled = true
                completion()
        }) { [weak self] (error, code) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                self.alertError(message: error.msg)
                self.newRequestButton.isEnabled = false
                self.retryButton.isHidden = false
                self.retryButton.isEnabled = true
                self.backgroundTitleLabel.text = "ERROR".localized()
                self.backgroundDescriptionLabel.text = "ERROR_MSG".localized()
            })
            completion()
        }
    }
    
    private func deleteRequest(index: Int) {
        let url = URLPath.applicationById + String(describing: self.data[index].id)
        Network.shared.delete(url: url, success: { [weak self, index] in
            guard let self = self else { return }
            let indexPath = IndexPath(item: index, section: 0)
            self.tableView.beginUpdates()
            self.data.remove(at: index)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
            self.tableView.reloadData()
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.alertError(message: error.localizedDescription)
        }
    }
    
    private func requestForDictinaryList() {
        Network.shared.request(
            url: URLPath.dictGet, method: .post,
            parameters: self.makeDictParametrs(),
            headers: ["auth-token": UserDefaults.standard.getUser().token],
            success: { (list: [DictionaryListModel]) in
                UserDefaults.standard.setDictionaryList(list: list)
        }) { (error, code) in
            print(error)
        }
    }
    
    // MARK: - Helpers
    
    private func reloadControllerData() {
        if self.data.count > 0 {
            self.tableView.reloadData()
            self.setBackgroundViewVisible(value: false)
        } else {
            self.setBackgroundViewVisible(value: true)
        }
    }
    
    private func makeDictParametrs() -> [String: [[String: Any]]] {
        let parametrs: [String: [[String: Any]]] =
            ["dicts": [
                ["name": "education","version": 0],
                ["name": "work_place","version": 0],
                ["name": "family_type","version": 0],
                ["name": "credit_kind","version": 0],
                ["name": "credit_targ","version": 0],
                ["name": "fo_bonuses","version": 0],
                ["name": "ft_money","version": 0],
                ["name": "pay_type","version": 0],
                ["name": "hm_score","version": 0],
                ["name": "have_property","version": 0],
                ["name": "have_car","version": 0],
                ["name": "names_city","version": 0],
                ["name": "regions","version": 0],
                ["name": "hm_relationship","version": 0]]]
        return parametrs
    }
    
    // MARK: - Alerts
    
    private func showDeleteAlert(id: Int) {
        let alertView = DeleteAlertView()
        alertView.yesButtonTappedHendler = { [weak self, id] in
            guard let self = self else { return }
            self.deleteRequest(index: id)
            SwiftEntryKit.dismiss()
        }
        SwiftEntryKit.display(entry: alertView,
                              using: EKAttributes.setupAttributes(statusBar: .light))
    }
    
    private func showPhoneActionSheet(for number: String) {
        let sheet = UIAlertController(title: "Позвонить", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(
            title: "Тел: \(number)", style: .default, handler: { _ in
                guard let url = URL(string: "tel://" + number) else { return }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
        }))
        
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }
}

  //***************************************************//
 //MARK: - UITableViewDelegate, UITableViewDataSource //
//***************************************************//

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredData.count : self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath)
        
        if !self.isFiltering {
            if self.data.count > 0 {
                let model: RequestViewModel = self.data[indexPath.row]
                (cell as? MainTableViewCell)?.initView(
                    statusImage: model.stateImage, name: model.fullName,
                    type: model.loanAmout, date: model.createdAt)
            }
        } else {
            if self.filteredData.count > 0 {
                let model: RequestViewModel = self.filteredData[indexPath.row]
                (cell as? MainTableViewCell)?.initView(
                    statusImage: model.stateImage, name: model.fullName,
                    type: model.loanAmout, date: model.createdAt)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var storyboard: UIStoryboard?
        var controller: UIViewController?
        var model: RequestViewModel?
        
        if self.isFiltering {
            if self.filteredData.count > 0 {
                model = self.filteredData[indexPath.row]
            }
        } else {
            if self.data.count > 0 {
                model = self.data[indexPath.row]
            }
        }
        
        if let model = model {
            switch model.state {
            case .uploaded:
                storyboard = UIStoryboard(name: "Forms", bundle: nil)
                controller = storyboard?.instantiateInitialViewController()
                (controller as? FormsRootViewController)?.requestId = model.id
                (controller as? FormsRootViewController)?.isEditable = false
                break
            case .draft:
                storyboard = UIStoryboard(name: "Forms", bundle: nil)
                controller = storyboard?.instantiateInitialViewController()
                (controller as? FormsRootViewController)?.requestId = model.id
                (controller as? FormsRootViewController)?.isEditable = true
                break
            case .rejected:
                storyboard = UIStoryboard(name: "Forms", bundle: nil)
                controller = storyboard?.instantiateInitialViewController()
                (controller as? FormsRootViewController)?.requestId = model.id
                (controller as? FormsRootViewController)?.isEditable = false
                break
            case .revision:
                storyboard = UIStoryboard(name: "Forms", bundle: nil)
                controller = storyboard?.instantiateInitialViewController()
                (controller as? FormsRootViewController)?.requestId = model.id
                (controller as? FormsRootViewController)?.isEditable = false
                (controller as? FormsRootViewController)?.isRevision = true
                break
            case .approved:
                storyboard = UIStoryboard(name: "Approved", bundle: nil)
                controller = storyboard?.instantiateInitialViewController()
                (controller as? ApprovedViewController)?.requestId = model.id
                break
                
            }
            
            if let controller = controller {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !self.isFiltering {
            let deleteAction = UIContextualAction(
                style: .normal, title:  "",
                handler: { [weak self, indexPath] (ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
                    guard let self = self else { return }
                    if self.data[indexPath.row].state == .draft {
                        self.showDeleteAlert(id: indexPath.row)
                    } else {
                        if let msg = "YOU_CAN_DELETE_ONLY_DRAFT".localized() {
                            self.alertError(message: msg)
                        }
                    }
                    success(true)
            })
            if let cgImage = UIImage(named: "contextualDelete")?.cgImage {
                deleteAction.image = ImageWithoutRender(
                    cgImage: cgImage, scale: 2, orientation: .up)
                deleteAction.backgroundColor = .white
            }
            
            let callAction = UIContextualAction(
                style: .normal, title:  "",
                handler: { [weak self, indexPath] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    guard let self = self else { return }
                    let number = self.data[indexPath.row].clientMainPhoneNum
                    self.showPhoneActionSheet(for: number)
                    success(true)
            })
            if let cgImage = UIImage(named: "contextualCall")?.cgImage {
                callAction.image =
                    ImageWithoutRender(cgImage: cgImage, scale: 2, orientation: .up)
                callAction.backgroundColor = .white
            }
            
            let config = UISwipeActionsConfiguration(actions: [deleteAction, callAction])
            config.performsFirstActionWithFullSwipe = false
            return config
        }
        return UISwipeActionsConfiguration(actions: [])
    }
    
    @available(iOS 9.0, *)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(
            style: .normal,
            title: "DELETE".localized()) { [weak self] (action, index) in
                guard let self = self else { return }
                if self.data[index.row].state == .draft {
                    self.showDeleteAlert(id: index.row)
                } else {
                    if let msg = "YOU_CAN_DELETE_ONLY_DRAFT".localized() {
                        self.alertError(message: msg)
                    }
                }
        }
        deleteAction.backgroundColor = AppColors.red.color()
        
        let callAction = UITableViewRowAction(
            style: .normal,
            title: "MAKE_CALL".localized()) { [weak self] (action, index) in
                guard let self = self else { return }
                let number = self.data[index.row].clientMainPhoneNum
                self.showPhoneActionSheet(for: number)
        }
        callAction.backgroundColor = AppColors.green.color()
        
        return [deleteAction, callAction]
    }
    
}

  //***************************************************//
 //          MARK: - UISearchBarDelegate              //
//***************************************************//

extension MainViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isFiltering = false
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isFiltering = true
        self.tableView.setEditing(false, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isFiltering = false
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.filterContent(searchText)
            self.isFiltering = true
        } else {
            self.isFiltering = false
        }
        self.tableView.reloadData()
    }
    
    private func filterContent(_ text: String) {
        self.filteredData = self.data.filter({ (data: RequestViewModel) -> Bool in
            return data.fullName.lowercased().contains(text.lowercased())
        })
    }
    
}

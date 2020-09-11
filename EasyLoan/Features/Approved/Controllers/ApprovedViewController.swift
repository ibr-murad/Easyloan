//
//  ApprovedViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/28/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import SnapKit

class ApprovedViewController: BaseViewController {
    
    // MARK: - Public Variables
    
    var requestId: Int? {
        didSet {
            self.getRequestFullModel()
        }
    }
    
    // MARK: - Private Variables
    
    private var allPhotosData: [PhotoCellModel] = []
    private var requestFull: RequestFullViewModel? {
        didSet {
            self.fetchItems()
            self.setupFooterView()
            self.loadImages()
        }
    }
    private var appovedItems: [ApprovedTableViewCellModel] = []
    
    // MARK: - GUI Variables
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let collectionView = UICollectionView(frame:
            CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView
            .register(ApprovedPhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: ApprovedPhotosCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Instantiate
    
    static func instantiate() -> ApprovedViewController {
        let storyboard = UIStoryboard(name: "Approved", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? ApprovedViewController
            else { return ApprovedViewController()}
        return controller
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var infoTableView: UITableView!
    
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.setupNavBar(style: .black, backgroungColor: UIColor(named: "appColor")!, tintColor: .white)
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
        }) { (error, code) in
            
        }
    }
    
    private func loadImages() {
        guard let request = self.requestFull else { return }
        let group = DispatchGroup()
        for (key, value) in request.files {
            group.enter()
            Network.shared.downloadImage(fileId: key) { [weak self] (image) in
                guard let self = self else { return }
                self.allPhotosData.append(PhotoCellModel(photo: image, status: .approved, type: value))
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.photosCollectionView.reloadData()
        }
    }
    
    private func fetchItems() {
        guard let request = self.requestFull else { return }
        var items: [ApprovedTableViewCellModel] = []
        self.navigationTitle = request.fullName
        if let cityId = request.actualAddress.city, let street = request.actualAddress.street {
            let actualAdressString = self.getNameById(id: cityId, from: .nameCity) + " ," + street
            items.append(.init(title: "ACTUAL_ADRESS".localized(), description: actualAdressString))
        }
        items.append(.init(title: "PHONE_NUMBER".localized(), description: request.clientPhoneNumber[0]))
        items.append(.init(title: "EMAIL".localized(), description: request.email))
        items.append(.init(title: "EDUCATION".localized(),
                           description: self.getNameById(id: "\(request.clientEducation)", from: .education)))
        items.append(.init(title: "FAMILY_STATUS".localized(),
                           description: self.getNameById(id: "\(request.familyStatus)", from: .familyType)))
        items.append(.init(title: "FAMILY_NUMBER".localized(), description: "\(request.familyMemberNum)"))
        items.append(.init(title: "DEPENDICIS_NUMBER".localized(), description: "\(request.familyMemberNum)"))
        items.append(.init(title: "MONTHLY_INCOME_NET".localized(), description: "\(request.monthlyNetIncome)"))
        items.append(.init(title: "MONTHLY_INCOME_NET_COM".localized(), description: request.monthlyNetIncomeCom))
        items.append(.init(title: "OPERATION_EXPENSES".localized(), description: "\(request.operationExpanses)"))
        items.append(.init(title: "FAMILY_EXPENSES".localized(), description: "\(request.familyExpenses)"))
        items.append(.init(title: "CLIENT_FAMILY_EXPENSES".localized(), description: "\(request.famClientExpenses)"))
        items.append(.init(title: "MONHTLY_ICOM".localized(), description: "\(request.monthlyIncome)"))
        items.append(.init(title: "EXPENSES_PER_FAMILY_MEMBER".localized(), description: "\(request.avgConsPerFamMember)"))
        if let cityId = request.workAddress.city, let street = request.workAddress.street {
            let workAdressString = self.getNameById(id: "\(cityId)", from: .nameCity) + " ," + street
            items.append(.init(title: "WORK_ADRESS".localized(), description: workAdressString))
        }
        items.append(.init(title: "WORK_PLACE".localized(), description: self.getNameById(id: "\(request.workPlace)", from: .workPlace)))
        items.append(.init(title: "EXPIRIENCE".localized(), description: "\(request.experience)"))
        items.append(.init(title: "HAVE_PROPERTY".localized(),
                           description: self.getNameById(id: "\(request.haveProperty)", from: .haveProperty)))
        items.append(.init(title: "HAVE_CAR".localized(),
                           description: self.getNameById(id: "\(request.haveCar)", from: .haveCar)))
        items.append(.init(title: "CREDIT_PRODUCT".localized(),
                           description: self.getNameById(id: "\(request.loanProduct)", from: .creditKind)))
        items.append(.init(title: "CREDIT_TARG".localized(),
                           description: self.getNameById(id: "\(request.loanPurpose)", from: .creditTarg)))
        items.append(.init(title: "CREDIT_TARG_COM".localized(), description: request.loanPurposeComment))
        items.append(.init(title: "LOAN_AMOUT".localized(), description: "\(request.loanAmount)"))
        items.append(.init(title: "LOAN_TERM".localized(), description: "\(request.loanTerm)"))
        items.append(.init(title: "LOAN_CURRENCY".localized(),
                           description: self.getNameById(id: "\(request.loanCurrency)", from: .ftMoney)))
        items.append(.init(title: "PAYMENT_TYPE".localized(),
                           description: self.getNameById(id: "\(request.paymentType)", from: .payType)))
        items.append(.init(title: "GRACE_PERIOD".localized(), description: "\(request.gracePeriod)"))
        items.append(.init(title: "LOAN_PERCENTAGE".localized(), description: "\(request.loanPercentage)"))
        items.append(.init(title: "LOAN_COEFFICIENT".localized(), description: "2.16"))
        for i in 0..<request.refereesInfo.count {
            guard let name = request.refereesInfo[i].name else { return }
            guard let phone = request.refereesInfo[i].phone else { return }
            guard var relation = request.refereesInfo[i].relation else { return }
            relation = self.getNameById(id: "\(relation)", from: .hm_elationship)
            guard let refStr = "REFEREE".localized() else { return }
            items.append(.init(title: refStr + " \(i+1)", description: name + "\n" + relation + "\n" + phone))
        }
        self.appovedItems = items
        self.infoTableView.reloadData()
    }
 
    // MARK: - Setters
    
    private func setupNavigationBar() {
        self.setupNavBar(style: .black, backgroungColor: UIColor(named: "greenTextColor")!, tintColor: .white)
    }
    
    // MARK: - Helpers
    
    private func getNameById(id: String, from: DictionaryNames) -> String {
        let dicts = UserDefaults.standard.getDictionaryByName(name: from)
        var name = ""
        if let id = Int(id) {
            for item in dicts {
                if item.id == id {
                    if let parentId = item.parentID {
                        let regionDicts = UserDefaults.standard.getDictionaryByName(name: .regions)
                        for region in regionDicts {
                            if let parentId = Int(parentId) {
                                if region.id == parentId {
                                    name.append(region.name + ", ")
                                    break
                                }
                            }
                            
                        }
                    }
                    name.append(item.name)
                    break
                }
            }
        }
        return name
    }
    
}


extension ApprovedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appovedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovedInfoCell", for: indexPath)
        
        if let labe = cell.textLabel as? LocalizedLabel {
            print("можно")
        }
        cell.textLabel?.text = self.appovedItems[indexPath.row].title
        cell.detailTextLabel?.text = self.appovedItems[indexPath.row].description
        return cell
    }
    
}

extension ApprovedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupFooterView() {
        guard let filesNumbers = self.requestFull?.files.count else { return }
        let headerViewWidth: CGFloat = self.view.frame.width
        var headerViewHeight: CGFloat = 0
        
        if filesNumbers <= 2 {
            headerViewHeight = 250
        } else if filesNumbers <= 4 {
            headerViewHeight = 500
        } else if filesNumbers <= 6 {
            headerViewHeight = 750
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: headerViewWidth, height: headerViewHeight))
        
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5))
        lineView.backgroundColor = .lightGray
        
        let label = UILabel()
        label.textColor = UIColor(named: "darkTextColor")
        label.text = "Файлы"
        
        headerView.addSubview(lineView)
        headerView.addSubview(label)
        headerView.addSubview(self.photosCollectionView)
        
        lineView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        label.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(lineView.snp.bottom).offset(16)
        }
        self.photosCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
        
        self.infoTableView.tableFooterView = headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allPhotosData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ApprovedPhotosCollectionViewCell.reuseIdentifier, for: indexPath)
            as? ApprovedPhotosCollectionViewCell else { return ApprovedPhotosCollectionViewCell() }
        
        let model = self.allPhotosData[indexPath.row]
        cell.initCell(image: model.photo, description: model.type)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 155)
    }
    
}

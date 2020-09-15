//
//  FormOneViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/23/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

class FormOneViewController: FormsBaseViewController {
    
    // MARK: - Public Variables
    
    override var requestFull: RequestFullViewModel? {
        didSet {
            self.setupViewsWithRequest()
        }
    }
    
    // MARK: - Private Variables
    
    private var phoneNumbers: [String] = [""]
    private let familyCalculateController = CalculateController()
    private let dependentCalculateController = CalculateController()
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var fullnameView: LabelAndTextFieldView!
    @IBOutlet private weak var regionDropDownView: DropMenuView!
    @IBOutlet private weak var cityDropDownView: DropMenuView!
    @IBOutlet private weak var locationTextField: FocusedTextField!
    @IBOutlet private weak var phoneNumbersCollectionView: UICollectionView!
    @IBOutlet private weak var emailView: LabelAndTextFieldView!
    @IBOutlet private weak var educationView: DropMenuView!
    @IBOutlet private weak var relationshipView: DropMenuView!
    @IBOutlet private weak var familyMinusButton: RoundedButton!
    @IBOutlet private weak var familyPlusButton: RoundedButton!
    @IBOutlet private weak var familyValueLabel: UILabel!
    @IBOutlet private weak var dependentMinusButton: RoundedButton!
    @IBOutlet private weak var dependentPlusButton: RoundedButton!
    @IBOutlet private weak var dependentValueLabel: UILabel!
    
    // MARK: - Instantiate
    
    static func instantiate() -> FormOneViewController {
        let storyboard = UIStoryboard(name: "FormOne", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "FormOne") as? FormOneViewController
            else { return FormOneViewController()}
        return controller
    }
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setIsEditable()
        self.setDelegates()
        self.setHendlers()
        self.setCulculateControllers()
    }
    
    
    // MARK: - Networking
    
    private func createNewRequest() {
        let parametrs: [String: Any] = self.makeParametrsForStep()
        Network.shared.request(
            url: URLPath.creatApplication, method: .post,
            parameters: parametrs,
            headers: ["auth-token": UserDefaults.standard.getUser().token],
            success: { [weak self] (data: CreateRequestModel) in
                guard let self = self else { return }
                self.isFormFullHandler?(data.check)
                self.continueButtonTappedHandler?()
                self.completionHendler?(data.id, Int(self.familyValueLabel.text ?? "1") ?? 1)
        }) { (error, code) in
            print(error)
        }
    }
    
    // MARK: - Actions
    
    @objc private func locationTypeViewTapped() {
        self.regionDropDownView.showDropDownList()
    }
    
    @objc private func locationNameViewTapped() {
        self.cityDropDownView.showDropDownList()
    }
    
    @objc private func educationViewTapped() {
        self.educationView.showDropDownList()
    }
    
    @objc private func relationshipViewTapped() {
        self.relationshipView.showDropDownList()
    }
    
    @IBAction private func addPhoneTextFieldButtonTapped(_ sender: RoundedButton) {
        if self.phoneNumbers.count < 3 {
            self.phoneNumbers.append("")
            let indexPath = IndexPath(item: self.phoneNumbers.count-1, section: 0)
            self.phoneNumbersCollectionView.insertItems(at: [indexPath])
            self.phoneNumbersCollectionView.reloadData()
        }
    }
    
    @IBAction private func familyMinusButtonTapped(_ sender: RoundedButton) {
        self.familyValueLabel.text =
            self.familyCalculateController.calculateUpdate(buttonSelected: sender)
    }
    
    @IBAction private func familyPlusButtonTappe(_ sender: RoundedButton) {
        self.familyValueLabel.text =
            self.familyCalculateController.calculateUpdate(buttonSelected: sender)
    }
    
    @IBAction private func dependentMinusButtonTapped(_ sender: RoundedButton) {
        self.dependentValueLabel.text =
            self.dependentCalculateController.calculateUpdate(buttonSelected: sender)
    }
    
    @IBAction private func dependentPlusButtonTapped(_ sender: RoundedButton) {
        self.dependentValueLabel.text =
            self.dependentCalculateController.calculateUpdate(buttonSelected: sender)
    }
    
    
    @IBAction private func continueButtonTapped(_ sender: RoundedButton) {
        if let fullName = self.fullnameView.textField.text {
            if fullName.count > 2 {
                self.createNewRequest()
            } else {
                self.alertError(message: "Заполните поле имени")
            }
        }
    }
    
    // MARK: - Helpers
    
    private func makeParametrsForStep() -> [String: Any] {
        var paramets: [String: Any] = [:]
        var numbers: [String] = []
        for cell in self.phoneNumbersCollectionView.visibleCells {
            if let cell = cell as? PhoneNumbersCollectionViewCell {
                numbers.append(cell.phoneTextField.text ?? "")
            }
        }
        paramets = [
            "fillStep": 1,
            "fullName": self.fullnameView.textField.text ?? "",
            "actualAddress": [
                "city": "\(self.cityDropDownView.selectedId)",
                "street": self.locationTextField.text ?? ""],
            "clientMainPhoneNum": numbers[0],
            "clientPhoneNumber": numbers,
            "email": self.emailView.textField.text ?? "",
            "clientEducation": self.educationView.selectedId.toInt(),
            "familyStatus": self.relationshipView.selectedId.toInt(),
            "familyMemberNum": self.familyCalculateController.calculateItem.value,
            "dependentsNum": self.dependentCalculateController.calculateItem.value
        ]
        if  let requestId = self.createdRequestId {
            paramets["id"] = requestId
        }
        return paramets
    }
    
    // MARK: - Setters
    
    private func setupViewsWithRequest() {
        guard let request = self.requestFull else { return }
        self.fullnameView.textField.text = request.fullName
        if let cityId = request.actualAddress.city {
            self.cityDropDownView.selectedId = cityId
        }
        self.locationTextField.text = request.actualAddress.street
        self.emailView.textField.text = request.email
        self.phoneNumbers = request.clientPhoneNumber
        self.phoneNumbersCollectionView.reloadData()
        self.educationView.selectedId = "\(request.clientEducation)"
        self.relationshipView.selectedId = "\(request.familyStatus)"
        self.familyCalculateController.calculateItem.value = request.familyMemberNum
        self.familyValueLabel.text = "\(request.familyMemberNum)"
        self.dependentCalculateController.calculateItem.value = request.dependentsNum
        self.dependentValueLabel.text = "\(request.dependentsNum)"
    }

    private func setupViews() {
        self.fullnameView.validateType = .name
        self.emailView.validateType = .email
        self.emailView.textField.keyboardType = .emailAddress
        self.setupDropDownView(view: self.regionDropDownView, dataName: .regions,
                               #selector(self.locationTypeViewTapped))
        self.setupDropDownView(view: self.cityDropDownView, dataName: .nameCity,
                               #selector(self.locationNameViewTapped))
        self.setupDropDownView(view: self.educationView, dataName: .education,
                               #selector(self.educationViewTapped))
        self.setupDropDownView(view: self.relationshipView, dataName: .familyType,
                               #selector(self.relationshipViewTapped))
    }
    
    private func setupDropDownView(view: DropMenuView, dataName: DictionaryNames, _ selector: Selector) {
        let tap = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.dataSource = UserDefaults.standard.getDictionaryByName(name: dataName)
    }
    
    private func setIsEditable() {
        if self.isEditable {
            self.scrollView.subviews.forEach {
                $0.isUserInteractionEnabled = true
            }
        } else {
            self.scrollView.subviews.forEach {
                $0.isUserInteractionEnabled = false
            }
        }
    }
    
    private func setHendlers() {
        self.regionDropDownView.selectedHendler = { [weak self] id in
            guard let self = self else { return }
            let data = UserDefaults.standard.getDictionaryByName(name: .nameCity)
                .filter( { return $0.parentID == id} )
            self.cityDropDownView.dataSource = data
            self.cityDropDownView.selectedId = "\(data[0].id)"
        }
        self.cityDropDownView.parentIdHedler = { id in
            self.regionDropDownView.selectedId = id
        }
    }
    
    private func setDelegates() {
        self.locationTextField.delegate = self
    }
    
    private func setCulculateControllers() {
        self.familyCalculateController.calculateItem =
            CalculateItem(minusButton: self.familyMinusButton, plusButton: self.familyPlusButton, value: 1, minValue: 1)
        self.familyValueLabel.text = "\(1)"
        self.dependentCalculateController.calculateItem =
            CalculateItem(minusButton: self.dependentMinusButton, plusButton: self.dependentPlusButton, value: 0, minValue: 0)
    }
    
}

  //*****************************//
 // MARK: - UITextFieldDelegate //
//*****************************//

extension FormOneViewController: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.locationTextField.layer.cornerRadius = 5
        self.locationTextField.layer.borderColor = UIColor.gray.cgColor
        self.locationTextField.layer.borderWidth = 1
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.locationTextField.layer.borderWidth = 0
    }
}

   //************************************//
  // MARK: - UICollectionViewDelegate,  //
 //         UICollectionViewDataSource //
//************************************//

extension FormOneViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.phoneNumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhoneNumbersCollectionViewCell.reuseIdentifier, for: indexPath)
        let number = self.phoneNumbers[indexPath.row]
        (cell as? PhoneNumbersCollectionViewCell)?.initCell(text: number)
        return cell
    }
    
}

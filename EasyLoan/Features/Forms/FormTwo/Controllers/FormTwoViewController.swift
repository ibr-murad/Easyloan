//
//  FormTwoViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/23/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class FormTwoViewController: FormsBaseViewController {
    
    // MARK: - Public Variables
    
    override var requestFull: RequestFullViewModel? {
        didSet {
            self.setupViewsWithRequest()
        }
    }
    
    override var familyMemberNum: Int {
        didSet {
            self.culculateAvgConsPerFamMember()
        }
    }
    
    // MARK: - Private Variables

    var monthlyIncome: Float = 0
    private var avgConsPerFamMember: Float = 0
    private let experienceCalculateController = CalculateController()
    private let homeRadionButtonController = RadioButtonController()
    private let carRadionButtonController = RadioButtonController()
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var clientMonthlyIncomeView: LabelAndTextFieldView!
    @IBOutlet weak var monthlyIncomeComTextField: UITextField!
    @IBOutlet weak var operationExpensesPerMonthView: LabelAndTextFieldView!
    @IBOutlet weak var familyExpensesPerMonthView: LabelAndTextFieldView!
    @IBOutlet weak var clientExpensesView: LabelAndTextFieldView!
    @IBOutlet weak var monthlyIncomeView: LabelAndTextFieldView!
    @IBOutlet weak var avgConsPerFamMemberView: LabelAndTextFieldView!
    @IBOutlet weak var workRegionDropDownView: DropMenuView!
    @IBOutlet weak var workCityDropDownView: DropMenuView!
    @IBOutlet weak var workStreetTextField: FocusedTextField!
    @IBOutlet weak var workPlaceDropDownView: DropMenuView!
    @IBOutlet weak var experienceMinusButton: RoundedButton!
    @IBOutlet weak var experiencePlusButton: RoundedButton!
    @IBOutlet weak var experinceValueLabel: UILabel!
    @IBOutlet weak var propertyDropDownView: DropMenuView!
    @IBOutlet weak var carDropDownView: DropMenuView!
    
    // MARK: - Instantiate
    
    static func instantiate() -> FormTwoViewController {
        let storyboard = UIStoryboard(name: "FormTwo", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "FormTwo") as? FormTwoViewController
            else { return FormTwoViewController()}
        return controller
    }
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setHendlers()
        self.setIsEditable()
        self.sutupButtonsControllers()
        self.setDelegates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Actions
    
    @IBAction func experienceMinusButtonTapped(_ sender: RoundedButton) {
        self.experinceValueLabel.text = self.experienceCalculateController.calculateUpdate(buttonSelected: sender)
    }
    @IBAction func experiencePlusButtonTapped(_ sender: RoundedButton) {
        self.experinceValueLabel.text = self.experienceCalculateController.calculateUpdate(buttonSelected: sender)
    }
    
    @objc private func workRegionDropDownViewTapped() {
        self.workRegionDropDownView.showDropDownList()
    }
    
    @objc private func workCityDropDownViewTapped() {
        self.workCityDropDownView.showDropDownList()
    }
    
    @objc private func workPlaceDropDownViewTapped() {
        self.workPlaceDropDownView.showDropDownList()
    }
    
    @objc private func propertyDropDownViewTapped() {
        self.propertyDropDownView.showDropDownList()
    }
    
    @objc private func carDropDownViewTapped() {
        self.carDropDownView.showDropDownList()
    }
    
    @IBAction func continueButtonTapped(_ sender: RoundedButton) {
        self.createNewRequest()
    }
    
    // MARK: - Requests
    
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
                self.completionHendler?(data.id, self.monthlyIncome)
        }) { (error, code) in
            print(error)
        }
    }
    
    // MARK: - Helpers
    
    private func makeParametrsForStep() -> [String: Any] {
        var paramets: [String: Any] = [:]
        if let id = self.createdRequestId {
            paramets = [
                "id": id,
                "fillStep": 2,
                "monthlyNetIncome": self.clientMonthlyIncomeView.textField.text?.toFloat() ?? 0,
                "monthlyNetIncomeCom": self.monthlyIncomeComTextField.text ?? "",
                "operationExpanses": self.operationExpensesPerMonthView.textField.text?.toFloat() ?? 0,
                "familyExpenses": self.familyExpensesPerMonthView.textField.text?.toFloat() ?? 0,
                "famClientExpenses": self.clientExpensesView.textField.text?.toFloat() ?? 0,
                "monthlyIncome": self.monthlyIncomeView.textField.text?.toFloat() ?? 0,
                "avgConsPerFamMember": self.avgConsPerFamMemberView.textField.text?.toFloat() ?? 0,
                "workAddress": [
                    "city": self.workCityDropDownView.selectedId.toInt(),
                    "street": self.workStreetTextField.text ?? ""],
                "workPlace": self.workPlaceDropDownView.selectedId.toInt(),
                "experience": self.experienceCalculateController.calculateItem.value,
                "haveProperty": self.propertyDropDownView.selectedId.toInt(),
                "haveCar": self.carDropDownView.selectedId.toInt()
            ]
        }
        return paramets
    }
    
    private func culculateMonthlyIncome() {
        guard let monthlyNetIncome = self.clientMonthlyIncomeView.textField.text?.toFloat(),
            let operationExpanses = self.operationExpensesPerMonthView.textField.text?.toFloat(),
            let familyExpenses = self.familyExpensesPerMonthView.textField.text?.toFloat()
            else { return }
        
        self.mIncome = monthlyNetIncome - operationExpanses - familyExpenses
        self.monthlyIncome = monthlyNetIncome - operationExpanses - familyExpenses
        self.monthlyIncomeView.textField.text = String(format: "%0.2f", self.mIncome)
    }
    
    private func culculateAvgConsPerFamMember() {
        if let familyExpensesPerMonthText = self.familyExpensesPerMonthView.textField.text {
            if let familyExpensesPerMonth = Float(familyExpensesPerMonthText) {
                let avgConsPerFamMember = familyExpensesPerMonth/Float(self.familyMemberNum)
                self.avgConsPerFamMemberView.textField.text = String(format: "%0.2f", avgConsPerFamMember)
            }
        }
    }    
    
    // MARK: - Setters
    
    private func setupViewsWithRequest() {
        guard let request = self.requestFull else { return }
        self.clientMonthlyIncomeView.textField.text = "\(request.monthlyNetIncome)"
        self.monthlyIncomeComTextField.text = request.monthlyNetIncomeCom
        self.operationExpensesPerMonthView.textField.text = "\(request.operationExpanses)"
        self.familyExpensesPerMonthView.textField.text = "\(request.familyExpenses)"
        self.clientExpensesView.textField.text = "\(request.famClientExpenses)"
        self.monthlyIncomeView.textField.text = "\(request.monthlyIncome)"
        self.mIncome = request.monthlyIncome
        self.avgConsPerFamMemberView.textField.text = "\(request.avgConsPerFamMember)"
        if let cityId = request.workAddress.city, let street = request.workAddress.street {
            self.workCityDropDownView.selectedId = String(describing: cityId)
            self.workStreetTextField.text = street
        }
        self.workPlaceDropDownView.selectedId = "\(request.workPlace)"
        self.experienceCalculateController.calculateItem.value = request.experience
        self.experinceValueLabel.text = "\(request.experience)"
        self.propertyDropDownView.selectedId = "\(request.haveProperty)"
        self.carDropDownView.selectedId = "\(request.haveCar)"
    }
    
    private func setupViews() {
        self.clientMonthlyIncomeView.didEndEditingHendler = { [weak self] in
            guard let self = self else { return }
            self.culculateMonthlyIncome()
        }
        self.operationExpensesPerMonthView.didEndEditingHendler = { [weak self] in
            guard let self = self else { return }
            self.culculateMonthlyIncome()
        }
        self.familyExpensesPerMonthView.didEndEditingHendler = { [weak self] in
            guard let self = self else { return }
            self.culculateAvgConsPerFamMember()
            self.culculateMonthlyIncome()
        }
        self.setupDropDownView(view: self.workRegionDropDownView, dataName: .regions,
                               #selector(self.workRegionDropDownViewTapped))
        self.setupDropDownView(view: self.workCityDropDownView, dataName: .nameCity,
                               #selector(self.workCityDropDownViewTapped))
        self.setupDropDownView(view: self.workPlaceDropDownView, dataName: .workPlace,
                               #selector(self.workPlaceDropDownViewTapped))
        self.setupDropDownView(view: self.propertyDropDownView, dataName: .haveProperty,
                               #selector(self.propertyDropDownViewTapped))
        self.setupDropDownView(view: self.carDropDownView, dataName: .haveCar,
                               #selector(self.carDropDownViewTapped))

    }
    
    private func sutupButtonsControllers() {
    self.experienceCalculateController.calculateItem =
            CalculateItem(minusButton: self.experienceMinusButton,
                          plusButton: self.experiencePlusButton, value: 6, minValue: 6)
    self.experinceValueLabel.text = "\(6)"
    }
    
    private func setDelegates() {
        self.monthlyIncomeComTextField.delegate = self
        self.workStreetTextField.delegate = self
    }
    
    private func setupDropDownView(view: DropMenuView, dataName: DictionaryNames, _ selector: Selector) {
        let tap = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.dataSource = UserDefaults.standard.getDictionaryByName(name: dataName)
    }
    
    private func setHendlers() {
        self.workRegionDropDownView.selectedHendler = { [weak self] id in
            guard let self = self else { return }
            let data = UserDefaults.standard.getDictionaryByName(name: .nameCity)
                .filter( { return $0.parentID == id} )
            self.workCityDropDownView.dataSource = data
            self.workCityDropDownView.selectedId = "\(data[0].id)"
        }
        self.workCityDropDownView.parentIdHedler = { id in
            self.workRegionDropDownView.selectedId = id
        }
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
}

  //*****************************//
 // MARK: - UITextFieldDelegate //
//*****************************//

extension FormTwoViewController: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layoutIfNeeded()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.clipsToBounds = true
        textField.layoutIfNeeded()
    }
}

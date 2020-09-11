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

    private var monthlyIncome: Float = 0
    private var avgConsPerFamMember: Float = 0
    
    private let experienceCalculateController = CalculateController()
    private let homeRadionButtonController = RadioButtonController()
    private let carRadionButtonController = RadioButtonController()
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var clientMonthlyIncomeView: LabelAndTextFieldView! {
        didSet {
            self.clientMonthlyIncomeView.didEndEditingHendler = { [weak self] in
                guard let self = self else { return }
                self.culculateMonthlyIncome()
            }
        }
    }
    @IBOutlet weak var monthlyIncomeComTextField: UITextField!
    @IBOutlet weak var operationExpensesPerMonthView: LabelAndTextFieldView! {
        didSet {
            self.operationExpensesPerMonthView.didEndEditingHendler = { [weak self] in
                guard let self = self else { return }
                self.culculateMonthlyIncome()
            }
        }
    }
    @IBOutlet weak var familyExpensesPerMonthView: LabelAndTextFieldView! {
        didSet {
            self.familyExpensesPerMonthView.didEndEditingHendler = { [weak self] in
                guard let self = self else { return }
                self.culculateAvgConsPerFamMember()
                self.culculateMonthlyIncome()
            }
        }
    }
    @IBOutlet weak var clientExpensesView: LabelAndTextFieldView!
    @IBOutlet weak var monthlyIncomeView: LabelAndTextFieldView!
    @IBOutlet weak var avgConsPerFamMemberView: LabelAndTextFieldView!
    @IBOutlet weak var workRegionDropDownView: DropMenuView! {
        didSet {
            self.setupDropDownView(view: self.workRegionDropDownView, dataName: .regions,
                                   #selector(self.workRegionDropDownViewTapped))
        }
    }
    @IBOutlet weak var workCityDropDownView: DropMenuView! {
        didSet {
            self.setupDropDownView(view: self.workCityDropDownView, dataName: .nameCity,
                                   #selector(self.workCityDropDownViewTapped))
        }
    }
    @IBOutlet weak var workStreetTextField: FocusedTextField!
    @IBOutlet weak var workPlaceDropDownView: DropMenuView! {
        didSet {
            self.setupDropDownView(view: self.workPlaceDropDownView, dataName: .workPlace,
                                   #selector(self.workPlaceDropDownViewTapped))
        }
    }
    @IBOutlet weak var experienceMinusButton: RoundedButton!
    @IBOutlet weak var experiencePlusButton: RoundedButton!
    @IBOutlet weak var experinceValueLabel: UILabel!
    @IBOutlet weak var propertyDropDownView: DropMenuView! {
        didSet {
            self.setupDropDownView(view: self.propertyDropDownView, dataName: .haveProperty,
                                   #selector(self.propertyDropDownViewTapped))
        }
    }
    @IBOutlet weak var carDropDownView: DropMenuView! {
        didSet {
            self.setupDropDownView(view: self.carDropDownView, dataName: .haveCar,
                                   #selector(self.carDropDownViewTapped))
        }
    }
    
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
                print(data)
                self.continueButtonTappedHandler?()
                self.completionHendler?(data.id, self.familyMemberNum)
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
                "monthlyNetIncome": self.stringToFloat(self.clientMonthlyIncomeView.textField.text),
                "monthlyNetIncomeCom": self.monthlyIncomeComTextField.text ?? "",
                "operationExpanses": self.stringToFloat(self.operationExpensesPerMonthView.textField.text),
                "familyExpenses": self.stringToFloat(self.familyExpensesPerMonthView.textField.text),
                "famClientExpenses": self.stringToFloat(self.clientExpensesView.textField.text),
                "monthlyIncome": self.stringToFloat(self.monthlyIncomeView.textField.text),
                "avgConsPerFamMember": self.stringToFloat(self.avgConsPerFamMemberView.textField.text),
                "workAddress": [
                    "city": self.stringToInt(self.workCityDropDownView.selectedId),
                    "street": self.workStreetTextField.text ?? ""],
                "workPlace": self.stringToInt(self.workPlaceDropDownView.selectedId),
                "experience": self.experienceCalculateController.calculateItem.value,
                "haveProperty": self.stringToInt(self.propertyDropDownView.selectedId),
                "haveCar": self.stringToInt(self.carDropDownView.selectedId),
            ]
        }
        return paramets
    }
    
    private func culculateMonthlyIncome() {
        let monthlyNetIncome = self.stringToFloat(self.clientMonthlyIncomeView.textField.text)
        let operationExpanses = self.stringToFloat(self.operationExpensesPerMonthView.textField.text)
        let familyExpenses = self.stringToFloat(self.familyExpensesPerMonthView.textField.text)
        self.monthlyIncome = monthlyNetIncome - operationExpanses - familyExpenses
        self.monthlyIncomeView.textField.text = "\(self.monthlyIncome)"
    }
    
    private func culculateAvgConsPerFamMember() {
        if let familyExpensesPerMonthText = self.familyExpensesPerMonthView.textField.text {
            if let familyExpensesPerMonth = Float(familyExpensesPerMonthText) {
                let avgConsPerFamMember = familyExpensesPerMonth/Float(self.familyMemberNum)
                self.avgConsPerFamMemberView.textField.text = String(format: "%0.2f", avgConsPerFamMember)
            }
        }
    }
    
    private func stringToFloat(_ str: String?) -> Float {
        var value: Float = 0
        if let str = str {
            if let valueFromString = Float(str) {
                value = valueFromString
            }
        }
        return value
    }
    
    private func stringToInt(_ str: String?) -> Int {
        var int = 0
        if let str = str {
            if let intFromString = Int(str) {
                int = intFromString
            }
        }
        return int
    }
    
    private func culculateForCoefficient() {
        guard let request = self.requestFull else { return }
        /*p = Процентная ставка / 100 / 12
         m = Сумма кредита * (p + p / ( (1+p).pow(Срок кредита) - 1))
         k = (Финансовые поступления клиента в месяц - Операционные расходы в месяц - Семейные расходы со стороны клиента) / m
         */
        
        let p = Double(request.loanPercentage) / 100 / 12
        let m = Double(request.loanAmount) * (p + p / Double(pow(Double(1 + p), Double(request.loanTerm) - 1)))
        let coef = Double(request.monthlyNetIncome - request.operationExpanses - request.famClientExpenses) / m
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
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.layer.borderWidth = 0
    }
}

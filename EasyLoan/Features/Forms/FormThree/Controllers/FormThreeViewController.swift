//
//  FormThreeViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/27/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class FormThreeViewController: FormsBaseViewController {
    
    // MARK: - Public Variables
    
    override var requestFull: RequestFullViewModel? {
        didSet {
            self.setupViewsWithRequest()
        }
    }
    
    // MARK: - Private Variables
    
    private let currencyRadionButtonController = RadioButtonController()
    private let gracePeriodCalculateController = CalculateController()
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loanProductDropDownView: DropMenuView!
    @IBOutlet weak var loanPurposeDropDownView: DropMenuView!
    @IBOutlet weak var loanPurposeComView: LabelAndTextFieldView!
    @IBOutlet weak var loanAmountView: LabelAndTextFieldView!
    @IBOutlet weak var loanTermView: LabelAndTextFieldView!
    @IBOutlet weak var paymentTypeDropDownView: DropMenuView!
    @IBOutlet weak var loanPercentageView: LabelAndTextFieldView!
    @IBOutlet weak var loanCoeffView: LabelAndTextFieldView!
    @IBOutlet weak var currencyTjsButton: RoundedButton!
    @IBOutlet weak var currencyUsdButton: RoundedButton!
    @IBOutlet weak var currencyRubButton: RoundedButton!
    @IBOutlet weak var gracePeriodMinusButton: RoundedButton!
    @IBOutlet weak var gracePeriodPlusButton: RoundedButton!
    @IBOutlet weak var gracePeriodValueLabel: UILabel!
    @IBOutlet weak var refereesOneNameView: LabelAndTextFieldView!
    @IBOutlet weak var refereesOnePhoneView: LabelAndTextFieldView!
    @IBOutlet weak var refereeOneRelationDropDownView: DropMenuView!
    @IBOutlet weak var refereesTwoNameView: LabelAndTextFieldView!
    @IBOutlet weak var refereesTwoPhoneView: LabelAndTextFieldView!
    @IBOutlet weak var refereeTwoRelationDropDownView: DropMenuView!
    
    // MARK: - Instantiate
    
    static func instantiate() -> FormThreeViewController {
        let storyboard = UIStoryboard(name: "FormThree", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "FormThree") as? FormThreeViewController
            else { return FormThreeViewController()}
        return controller
    }
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setIsEditable()
        self.sutupButtonsControllers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - Actions
    
    @objc private func loanProductDropDownViewTapped() {
        self.loanProductDropDownView.showDropDownList()
    }
    @objc private func loanPurposeDropDownViewTapped() {
        self.loanPurposeDropDownView.showDropDownList()
    }
    @objc private func paymentTypeDropDownViewTapped() {
        self.paymentTypeDropDownView.showDropDownList()
    }
    @objc private func refereeOneRelationDropDownViewTapped() {
        self.refereeOneRelationDropDownView.showDropDownList()
    }
    @objc private func refereeTwoRelationDropDownViewTapped() {
        self.refereeTwoRelationDropDownView.showDropDownList()
    }
    
    @IBAction func currencyTjsButtonTapped(_ sender: RoundedButton) {
        self.currencyRadionButtonController.buttonArrayUpdated(buttonSelected: sender)
    }
    @IBAction func currencyUsdButtonTapped(_ sender: RoundedButton) {
        self.currencyRadionButtonController.buttonArrayUpdated(buttonSelected: sender)
    }
    @IBAction func currencyRubButtonTapped(_ sender: RoundedButton) {
        self.currencyRadionButtonController.buttonArrayUpdated(buttonSelected: sender)
    }
    
    @IBAction func gracePeriodMinusButtonTapped(_ sender: RoundedButton) {
        self.gracePeriodValueLabel.text =
            self.gracePeriodCalculateController.calculateUpdate(buttonSelected: sender)
    }
    @IBAction func gracePeriodPlusButtonTapped(_ sender: RoundedButton) {
        self.gracePeriodValueLabel.text =
            self.gracePeriodCalculateController.calculateUpdate(buttonSelected: sender)
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
                "fillStep": 3,
                "loanProduct": self.loanProductDropDownView.selectedId.toInt(),
                "loanPurpose": self.loanPurposeDropDownView.selectedId.toInt(),
                "loanPurposeComment": self.loanPurposeComView.textField.text ?? "",
                "loanAmount": self.loanAmountView.textField.text?.toFloat() ?? 0,
                "loanTerm": self.loanTermView.textField.text?.toInt() ?? 0,
                "loanCurrency": self.currencyRadionButtonController.selectedButton?.value.toInt() ?? 0,
                "paymentType": self.paymentTypeDropDownView.selectedId.toInt(),
                "gracePeriod": self.gracePeriodValueLabel.text?.toInt() ?? 0,
                "loanPercentage": self.loanPercentageView.textField.text?.toFloat() ?? 0,
                "refereesInfo": [
                    ["name": self.refereesOneNameView.textField.text ?? "",
                     "phone": self.refereesOnePhoneView.textField.text ?? "",
                     "relation": self.refereeOneRelationDropDownView.selectedId],
                    ["name": self.refereesTwoNameView.textField.text ?? "",
                     "phone": self.refereesTwoPhoneView.textField.text ?? "",
                     "relation": self.refereeTwoRelationDropDownView.selectedId]
                ]
            ]
        }
        return paramets
    }
    
    private func culculateForCoefficient() {
        guard let request = self.requestFull else { return }
        
        guard let loanAmount = self.loanAmountView.textField.text?.toDouble(),
            let loanTerm = self.loanTermView.textField.text?.toDouble(),
            let loanPercentage = self.loanPercentageView.textField.text?.toDouble()
            else {
                return
        }
        
        let p = loanPercentage / 100.0 / 12.0
        let m = loanAmount * (p + p / ( pow((1 + p), loanTerm) - 1 ))
        let k = Double(request.monthlyNetIncome -
            request.operationExpanses - request.famClientExpenses) / m
        
        self.loanCoeffView.textField.text = String(format: "%0.2f", k)
    }
    

    // MARK: - Setters
    
    private func setupViewsWithRequest() {
        guard let request = self.requestFull else { return }
        self.loanProductDropDownView.selectedId = "\(request.loanProduct)"
        self.loanPurposeDropDownView.selectedId = "\(request.loanPurpose)"
        self.loanPurposeComView.textField.text = request.loanPurposeComment
        self.loanAmountView.textField.text = "\(request.loanAmount)"
        self.loanTermView.textField.text = "\(request.loanTerm)"
        self.currencyRadionButtonController.setSelectedByValue(value: "\(request.loanCurrency)")
        self.paymentTypeDropDownView.selectedId = "\(request.paymentType)"
        self.gracePeriodCalculateController.calculateItem.value = request.gracePeriod
        self.gracePeriodValueLabel.text = "\(request.gracePeriod)"
        self.loanPercentageView.textField.text = "\(request.loanPercentage)"
        self.culculateForCoefficient()
        if request.refereesInfo.count > 0 {
            self.refereesOneNameView.textField.text = request.refereesInfo[0].name
            self.refereesOnePhoneView.textField.text = request.refereesInfo[0].phone
            guard let relation = request.refereesInfo[0].relation else { return }
            self.refereeOneRelationDropDownView.selectedId = relation
        }
        if request.refereesInfo.count > 1 {
            self.refereesTwoNameView.textField.text = request.refereesInfo[1].name
            self.refereesTwoPhoneView.textField.text = request.refereesInfo[1].phone
            guard let relation = request.refereesInfo[1].relation else { return }
            self.refereeTwoRelationDropDownView.selectedId = relation
        }
    }
    
    private func setupDropDownView(view: DropMenuView, dataName: DictionaryNames, _ selector: Selector) {
        let tap = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.dataSource = UserDefaults.standard.getDictionaryByName(name: dataName)
    }
    
    private func setupViews() {
        self.refereesOneNameView.validateType = .name
        self.refereesOnePhoneView.validateType = .phone
        self.refereesTwoNameView.validateType = .name
        self.refereesTwoPhoneView.validateType = .phone
        self.setupDropDownView(view: self.loanProductDropDownView, dataName: .creditKind,
                               #selector(self.loanProductDropDownViewTapped))
        self.setupDropDownView(view: self.loanPurposeDropDownView, dataName: .creditTarg,
                               #selector(self.loanPurposeDropDownViewTapped))
        self.setupDropDownView(view: self.paymentTypeDropDownView, dataName: .payType,
                               #selector(self.paymentTypeDropDownViewTapped))
        self.setupDropDownView(view: self.refereeOneRelationDropDownView, dataName: .hm_elationship,
                               #selector(self.refereeOneRelationDropDownViewTapped))
        self.setupDropDownView(view: self.refereeTwoRelationDropDownView, dataName: .hm_elationship,
                               #selector(self.refereeTwoRelationDropDownViewTapped))
        self.loanAmountView.didEndEditingHendler = { [weak self] in
            guard let self = self else { return }
            self.culculateForCoefficient()
        }
        self.loanTermView.didEndEditingHendler = { [weak self] in
            guard let self = self else { return }
            self.culculateForCoefficient()
        }
        self.loanPercentageView.didEndEditingHendler = { [weak self] in
            guard let self = self else { return }
            self.culculateForCoefficient()
        }
    }
    
    private func sutupButtonsControllers() {
        let tjs = RadioButton(button: self.currencyTjsButton, value: "3534157618")
        let usd = RadioButton(button: self.currencyUsdButton, value: "3534157763")
        let rub = RadioButton(button: self.currencyRubButton, value: "3534157494")
        self.currencyRadionButtonController.buttonsArray = [tjs, usd, rub]
        self.currencyRadionButtonController.defaultButton = tjs
        
        self.gracePeriodCalculateController.calculateItem =
            CalculateItem(minusButton: self.gracePeriodMinusButton, plusButton: self.gracePeriodPlusButton, value: 0, minValue: 0)
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

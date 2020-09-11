//
//  FilterPopoverViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/12/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import DropDown

class FilterPopoverViewController: UIViewController {
    
    // MARK: - Private Variables
    
    private let datePickerFrom = UIDatePicker()
    private let datePickerTo = UIDatePicker()
    
    // MARK: - Outlets
    
    @IBOutlet weak var periodSlide: UISlider!
    @IBOutlet weak var fromDropDownView: DropMenuView!
    @IBOutlet weak var toDropDownView: DropMenuView!
    @IBOutlet weak var pickerFromTextField: UITextField!
    @IBOutlet weak var pickerToTextField: UITextField!
    
    // MARK: - Instantiate
    
    static func instantiate() -> FilterPopoverViewController {
        let storyboard = UIStoryboard(name: "Statistics", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "Filter") as? FilterPopoverViewController
            else { return FilterPopoverViewController()}
        return controller
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupDatePickers()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Actions
    
    @IBAction func periodSliderValueChanged(_ sender: UISlider) {
        sender.value = sender.value.rounded()
        switch sender.value {
        case 1:
            self.setPickerDateWithComponents(picker: self.datePickerFrom, monthsToAdd: -1)
            break
        case 2:
            self.setPickerDateWithComponents(picker: self.datePickerFrom, monthsToAdd: -3)
            break
        case 3:
            self.setPickerDateWithComponents(picker: self.datePickerFrom, monthsToAdd: -6)
            break
        case 4:
            self.setPickerDateWithComponents(picker: self.datePickerFrom, monthsToAdd: -12)
            break
        default:
            break
        }
        self.fromDropDownView.label.text = self.getStringFromDate(date: self.datePickerFrom.date)
    }
    
    @objc private func dateFromChanged() {
        self.fromDropDownView.label.text = self.getStringFromDate(date: self.datePickerFrom.date)
    }
    
    @objc private func dateToChanged() {
        self.toDropDownView.label.text = self.getStringFromDate(date: self.datePickerTo.date)
    }
    
    private func getStringFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    // MARK: - Setters
    
    private func setupViews() {
        self.pickerFromTextField.inputView = self.datePickerFrom
        self.pickerToTextField.inputView = self.datePickerTo
        self.datePickerFrom.datePickerMode = .date
        self.datePickerTo.datePickerMode = .date
    }
    
    private func setupDatePickers() {
        self.datePickerFrom.addTarget(self, action: #selector(self.dateFromChanged), for: .valueChanged)
        self.datePickerTo.addTarget(self, action: #selector(self.dateToChanged), for: .valueChanged)
        
        self.setPickerDateWithComponents(picker: self.datePickerFrom, monthsToAdd: -3)
        self.fromDropDownView.label.text = self.getStringFromDate(date: self.datePickerFrom.date)
        
        self.datePickerTo.date = Date()
        self.toDropDownView.label.text = self.getStringFromDate(date: self.datePickerTo.date)
    }
    
    private func setPickerDateWithComponents(picker: UIDatePicker, monthsToAdd: Int?) {
        var dateComponent = DateComponents()
        let currentDate = self.datePickerTo.date
        if let months = monthsToAdd {
            dateComponent.month = months
        }
        if let newDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) {
            picker.date = newDate
        }
    }
    
}

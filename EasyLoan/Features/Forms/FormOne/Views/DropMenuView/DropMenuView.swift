//
//  DropMenuView.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/22/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//


import UIKit
import DropDown

@IBDesignable
class DropMenuView: UIView {
    
    // MARK: - Public Variables
    
    var selectedHendler: ((String) -> Void)?
    var parentIdHedler: ((String) -> Void)?
    
    @IBInspectable
    var title: String = "none" {
        didSet {
            self.label.text = self.title
        }
    }
    
    var selectedId: String = "0" {
        didSet {
            guard let dicts = self.dataSource else { return }
            self.label.text = self.getNameById(id: self.selectedId)
            if let element = dicts.first(where: {$0.parentID != nil && $0.id == Int(self.selectedId)}) {
                self.parentIdHedler?(element.parentID ?? "")
            }
        }
    }
    
    var dataSource: [DictionaryItemModel]? {
        didSet {
            guard let dicts = self.dataSource else { return }
            var dataSource: [String] = []
            for value in dicts {
                dataSource.append(value.name)
            }
            self.dropDown.dataSource = dataSource
        }
    }
    
    // MARK: - Private Variables
    
    private let dropDown = DropDown()
    
    // MARK: - Outlets
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    // MARKL - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    // MARK: - Setters
    
    private func setupViews() {
        let xibView = self.loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DropMenuView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    // MARK: - Helpers
    
    func showDropDownList() {
        self.dropDown.selectionBackgroundColor = .white
        self.dropDown.anchorView = self
        self.dropDown.backgroundColor = .white
        self.dropDown.selectionAction =
            { [weak self] (index: Int, item: String) in
                guard let self = self else { return }
                guard let dicts = self.dataSource else { return }
                self.selectedId = "\(dicts[index].id)"
                self.selectedHendler?(self.selectedId)
        }
        self.dropDown.show()
    }
    
    func getNameById(id: String) -> String {
        var name = ""
        if let id = Int(id), let dicts = self.dataSource {
            for value in dicts where value.id == id {
                name = value.name
            }
        }
        return name
    }
}




/*import UIKit
import DropDown

@IBDesignable
class DropMenuView: UIView {
    
    // MARK: - Public Variables
    
    var hendler: ((String) -> Void)?
    var parentIdHedler: ((String) -> Void)?
    
    @IBInspectable
    var title: String = "none" {
        didSet {
            self.label.text = self.title
        }
    }
    
    var selectedId: String = "0" {
        didSet {
            self.label.text = self.getNameById(id: self.selectedId)
            guard let dicts = self.dataSource else { return }
            if let element = dicts.first(where: {$0.parentID != nil && $0.id == Int(self.selectedId)}) {
                self.parentIdHedler?(element.parentID ?? "")
            }
        }
    }
    
    var parentId: String? {
        didSet {
            guard let parentId = self.parentId else { return }
            guard let dicts = self.dataSource else { return }
            self.parentIdHedler?(parentId)
            self.names = []
            self.ids = []
            for value in dicts where value.parentID ?? "" == parentId {
                self.names.append(value.name)
                self.ids.append(value.id)
            }
            if self.ids.count > 0 {
                self.selectedId = "\(self.ids[0])"
                self.dropDown.dataSource = self.names
            }
        }
    }
    
    var dataSource: [DictionaryItemModel]? {
        didSet {
            guard let dicts = self.dataSource else { return }
            var haveParent = false
            for value in dicts {
                self.names.append(value.name)
                self.ids.append(value.id)
                if value.parentID != nil {
                    self.parentId = value.parentID
                    haveParent = true
                }
            }
            if self.ids.count > 0 && !haveParent {
                self.selectedId = "\(self.ids[0])"
                self.dropDown.dataSource = self.names
            }
        }
    }
    
    // MARK: - Private Variables
    
    private let dropDown = DropDown()
    private var names: [String] = []
    private var ids: [Int] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    // MARKL - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    // MARK: - Setters
    
    private func setupViews() {
        let xibView = self.loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DropMenuView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    // MARK: - Helpers
    
    func showDropDownList() {
        self.dropDown.selectionBackgroundColor = .white
        self.dropDown.anchorView = self
        self.dropDown.backgroundColor = .white
        self.dropDown.selectionAction =
            { [weak self] (index: Int, item: String) in
                guard let self = self else { return }
                self.selectedId = "\(self.ids[index])"
                self.hendler?(self.selectedId)
        }
        self.dropDown.show()
    }
    
    func getNameById(id: String) -> String {
        var name = ""
        if let id = Int(id) {
            for i in 0..<self.names.count {
                if self.ids[i] == id {
                    name = self.names[i]
                }
            }
        }
        return name
    }
}*/

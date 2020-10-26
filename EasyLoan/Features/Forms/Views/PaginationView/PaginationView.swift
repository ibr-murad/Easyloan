//
//  PaginationView.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/3/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

@IBDesignable
class PaginationView: UIView {
    
    // MARK: - variable handlers
    
    var stepOneButtonTappedHandler: (() -> Void)?
    var stepTwoButtonTappedHandler: (() -> Void)?
    var stepThreeButtonTappedHandler: (() -> Void)?
    var stepFourButtonTappedHandler: (() -> Void)?
    var stepFiveButtonTappedHandler: (() -> Void)?
   
    // MARK: - gui variables
    
    private var selectedButton: RoundedButton?
    
    // MARK: - outlets
    
    @IBOutlet var buttons: [RoundedButton]!
    
    @IBOutlet weak var stepOneButton: RoundedButton! {
        didSet {
            self.updateSelectedButton(buttonSelected: self.stepOneButton)
        }
    }
    @IBOutlet weak var stepTwoButton: RoundedButton!
    @IBOutlet weak var stepThreeButton: RoundedButton!
    @IBOutlet weak var stepFourButton: RoundedButton!
    @IBOutlet weak var stepFiveButton: RoundedButton!
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupViews()
    }
  
    // MARK: - actions
    
    @IBAction func stepOneButtonTapped(_ sender: RoundedButton) {
        self.stepOneButtonTappedHandler?()
        self.updateSelectedButton(buttonSelected: sender)
    }
    
    @IBAction func stepTwoButtonTapped(_ sender: RoundedButton) {
        self.stepTwoButtonTappedHandler?()
        self.updateSelectedButton(buttonSelected: sender)
    }
    
    @IBAction func stepThreeButtonTapped(_ sender: RoundedButton) {
        self.stepThreeButtonTappedHandler?()
        self.updateSelectedButton(buttonSelected: sender)
    }
    
    @IBAction func stepFourButtonTapped(_ sender: RoundedButton) {
        self.stepFourButtonTappedHandler?()
        self.updateSelectedButton(buttonSelected: sender)
    }
    
    @IBAction func stepFiveButtonTapped(_ sender: RoundedButton) {
        self.stepFiveButtonTappedHandler?()
        self.updateSelectedButton(buttonSelected: sender)
    }
    
    // MARK: -setters
    
    private func highlightButton(button: RoundedButton) {
        guard let image = UIImage(named: "selectedIcon") else { return }
        button.image = image
    }
    
    private func unHighlightButton(button: RoundedButton) {
        button.image = UIImage()
    }
    
    // MARK: - helpers
    
    func updateSelectedButton(buttonSelected: RoundedButton) {
        for i in self.buttons {
            if i == buttonSelected {
                self.selectedButton = i
                self.highlightButton(button: i)
                i.isSelected = true
            } else {
                self.unHighlightButton(button: i)
                i.isSelected = false
            }
        }
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PaginationView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
}

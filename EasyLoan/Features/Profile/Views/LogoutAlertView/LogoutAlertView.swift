//
//  LogoutAlertView.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 9/11/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import SwiftEntryKit

@IBDesignable
class LogoutAlertView: UIView {
    
    var yesButtonTappedHendler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    @IBAction func yesButtonTapped(_ sender: RoundedButton) {
        self.yesButtonTappedHendler?()
    }
    
    @IBAction func noButtonTapped(_ sender: RoundedButton) {
        SwiftEntryKit.dismiss()
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LogoutAlertView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
}

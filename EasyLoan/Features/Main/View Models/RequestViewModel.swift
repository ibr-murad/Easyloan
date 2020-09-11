//
//  RequestViewModel.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/25/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

struct RequestViewModel {
    var id: Int
    var fullName: String
    var state: RequestState
    var createdAt: String
    var loanAmout: String
    var clientMainPhoneNum: String
    var stateImage: UIImage
    
    init(model: RequestModel) {
        self.id = model.id
        self.fullName = model.fullName ?? ""
        self.state = RequestState.init(stringState: model.state)
        self.createdAt = model.createdAt ?? ""
        if let amount = model.loanAmount {
            self.loanAmout = String(amount)
        } else {
            self.loanAmout = ""
        }
        self.clientMainPhoneNum = model.clientMainPhoneNum ?? ""
        if let image = UIImage(named: self.state.rawValue) {
            self.stateImage = image
        } else {
            self.stateImage = UIImage()
        }
    }
}


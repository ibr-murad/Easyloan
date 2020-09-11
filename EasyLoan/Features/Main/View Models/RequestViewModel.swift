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

enum RequestState: String {
    case approved = "completedIcon"
    case draft    = "draftIcon"
    case rejected = "canceledIcon"
    case uploaded = "warningIcon"
    case revision = "barterIcon"
    
    init(stringState: String) {
        switch stringState {
        case "APPROVED":
            self = .approved
            break
        case "DRAFT":
            self = .draft
            break
        case "REJECTED":
            self = .rejected
            break
        case "UPLOADED":
            self = .uploaded
            break
        case "REVISION":
            self = .revision
            break
        default:
            self = .draft
            break
        }
    }
}


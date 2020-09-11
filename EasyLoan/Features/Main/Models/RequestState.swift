//
//  RequestStatus.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/27/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

enum RequestState: String {
    case approved = "statusApproved"
    case rejected = "statusRejected"
    case draft = "statusDraft"
    case revision = "statusRevision"
    case uploaded = "statusUploaded"
    
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

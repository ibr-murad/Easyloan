//
//  RequestsOrderBy.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 9/8/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

enum RequestsOrderBy: String {
    case date = "date"
    case name = "name"
    case approved = "approved"
    case rejected = "rejected"
    case draft = "draft"
    case uploaded = "uploaded"
    case revision = "revision"
    
    func getLocalized() -> String? {
        switch self {
        case .date:
            return "".localized()
        case .name:
            return "".localized()
        case .approved:
            return "ORDER_BY_APPROVED".localized()
        case .rejected:
            return "ORDER_BY_REJECTED".localized()
        case .draft:
            return "ORDER_BY_DRAFT".localized()
        case .uploaded:
            return "ORDER_BY_UPLOADED".localized()
        case .revision:
            return "ORDER_BY_REVISION".localized()
        }
    }
}

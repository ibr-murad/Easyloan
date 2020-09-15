//
//  DocumetsPhotoModel.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/6/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

struct PhotoCellModel {
    var photo: UIImage
    var status: RequestState
    var type: String
    var fileId: String?
    var typeText: String {
        return self.setTypeText(type: self.type)
    }
    
    private func setTypeText(type: String) -> String {
        var text: String?
        switch type {
        case "PAS":
            text = "PASSPORT".localized()
            break
        case "TIN":
            text = "INN".localized()
            break
        case "INC":
            text = "INCOME_STATEMENT".localized()
            break
        case "APP":
            text = "REQUEST_FOR_LOAN".localized()
            break
        case "PHO":
            text = "CLIENT_PHOTO".localized()
            break
        case "OTH":
            text = "OTHER_DOCUMENTS".localized()
            break
        default:
            break
        }
        guard let uwrappedText = text else { return "Документ"}
        return uwrappedText
    }
}

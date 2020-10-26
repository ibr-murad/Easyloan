//
//  NotificationViewModel.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 9/28/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

struct NotificationViewModel {
    
    var id: Int
    var title: String
    var text: String
    var createdAt: String
    var state: String
    var stateImage: UIImage = UIImage()
    
    init(model: NotificationModel) {
        self.id = model.id
        self.title = model.title
        self.text = model.text
        self.createdAt = model.createdAt
        self.state = model.state ?? ""
        var imageName = ""
        switch self.state {
        case "APPROVED":
            imageName = "statusApproved"
            break
        case "REJECTED":
            imageName = "statusRejected"
            break
        case "REVISION":
            imageName = "statusRevision"
            break
        case "UPLOADED":
            imageName = "statusUploaded"
            break
        default:
            imageName = "humoIcon"
            break
        }
        if let image = UIImage(named: imageName) {
            self.stateImage = image
        }
    }
    
}

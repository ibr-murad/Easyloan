//
//  NotificationModel.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 9/22/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct NotificationModel: Codable {
    var id: Int
    var title: String
    var text: String
    var createdAt: String
    var state: String?
}

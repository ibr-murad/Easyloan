//
//  RequestModel.swift
//  TaskForMiddle
//
//  Created by Murad Ibrohimov on 7/20/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

struct RequestModel: Codable {
    var id: Int
    var fullName: String
    var state: String
    var createdAt: String
    var clientMainPhoneNum: String
}

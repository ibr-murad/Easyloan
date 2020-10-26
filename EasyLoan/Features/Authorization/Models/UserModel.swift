//
//  UserModel.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/21/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct UserModel: Codable{
    var token: String
    var user: User
}

struct User: Codable {
    var id: Int
    var cftId: Int
    var fullName: String
    var phoneNumber:String
    var departName: String
    var departCode: String
    var appAccess: Int
}

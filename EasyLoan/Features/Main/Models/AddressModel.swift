//
//  AddresModel.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/24/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct ActualAddressModel: Codable {
    var city: String?
    var street: String?
}

struct WorkAddressModel: Codable {
    var city: Int?
    var street: String?
}

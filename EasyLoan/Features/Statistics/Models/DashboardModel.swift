//
//  DashboardModel.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 9/1/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct DashboardModel: Codable {
    var activePortfolio: Float?
    var monthSum: Float?
    var par1: Float?
    var par30: Float?
    var activeClients: Int?
    var credNum: Int?
    var delaySum1: Float?
    var delaySum30: Float?
    var reportDate: String?
}

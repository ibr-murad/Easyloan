//
//  RequestFullModel.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/24/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct RequestFullModel: Codable { 
    var id: Int
    var fullName: String?
    var actualAddress: ActualAddressModel?
    var clientPhoneNumber: [String]?
    var email: String?
    var clientEducation: Int?
    var familyStatus: Int?
    var familyMemberNum: Int?
    var dependentsNum: Int?
    var monthlyNetIncome: Float?
    var monthlyNetIncomeCom: String?
    var operationExpanses: Float?
    var familyExpenses: Float?
    var famClientExpenses: Float?
    var monthlyIncome: Float?
    var avgConsPerFamMember: Float?
    var workAddress: WorkAddressModel?
    var workPlace: Int?
    var experience: Int?
    var haveProperty: Int?
    var haveCar: Int?
    var loanProduct: Int?
    var loanPurpose: Int?
    var loanPurposeComment: String?
    var loanAmount: Float?
    var loanTerm: Int?
    var loanCurrency: Int?
    var paymentType: Int?
    var gracePeriod: Int?
    var loanPercentage: Float?
    var refereesInfo: [RefereesInfoModel]?
    var stepFirst: Bool?
    var stepSecond: Bool?
    var stepThird: Bool?
    var stepFive: Bool?
    var state: String?
    var files: [String: String]?
    var createdBy: Int?
    var filledSteps: Int?
    var cftMessage: String?
    var clientMainPhoneNum: String?
}

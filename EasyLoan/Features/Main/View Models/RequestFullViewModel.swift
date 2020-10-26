//
//  RequestFullViewModel.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/25/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct RequestFullViewModel {
    var id: Int
    var fullName: String
    var actualAddress: ActualAddressModel
    var clientPhoneNumber: [String]
    var email: String
    var clientEducation: Int
    var familyStatus: Int
    var familyMemberNum: Int
    var dependentsNum: Int
    var monthlyNetIncome: Float
    var monthlyNetIncomeCom: String
    var operationExpanses: Float
    var familyExpenses: Float
    var famClientExpenses: Float
    var monthlyIncome: Float
    var avgConsPerFamMember: Float
    var workAddress: WorkAddressModel
    var workPlace: Int
    var experience: Int
    var haveProperty: Int
    var haveCar: Int
    var loanProduct: Int
    var loanPurpose: Int
    var loanPurposeComment: String
    var loanAmount: Float
    var loanTerm: Int
    var loanCurrency: Int
    var paymentType: Int
    var gracePeriod: Int
    var loanPercentage: Float
    var refereesInfo: [RefereesInfoModel]
    var stepFirst: Bool
    var stepSecond: Bool
    var stepThird: Bool
    var stepFive: Bool
    var state: String
    var files: [String: String]
    var createdBy: Int
    var filledSteps: Int
    var cftMessage: String
    var clientMainPhoneNum: String
    
    init(request: RequestFullModel) {
        self.id = request.id
        self.fullName = request.fullName ?? ""
        self.actualAddress = request.actualAddress ?? ActualAddressModel(city: "0", street: "")
        self.clientPhoneNumber = request.clientPhoneNumber ?? [""]
        self.email = request.email ?? ""
        self.clientEducation = request.clientEducation ?? 0
        self.familyStatus = request.familyStatus ?? 0
        self.familyMemberNum = request.familyMemberNum ?? 1
        self.dependentsNum = request.dependentsNum ?? 1
        self.monthlyNetIncome = request.monthlyNetIncome ?? 0
        self.monthlyNetIncomeCom = request.monthlyNetIncomeCom ?? ""
        self.operationExpanses = request.operationExpanses ?? 0
        self.familyExpenses = request.familyExpenses ?? 0
        self.famClientExpenses = request.famClientExpenses ?? 0
        self.monthlyIncome = request.monthlyIncome ?? 0
        self.avgConsPerFamMember = request.avgConsPerFamMember ?? 0
        self.workAddress = request.workAddress ?? WorkAddressModel(city: 0, street: "")
        self.workPlace = request.workPlace ?? 0
        self.experience = request.experience ?? 6
        self.haveProperty = request.haveProperty ?? 0
        self.haveCar = request.haveCar ?? 0
        self.loanProduct = request.loanProduct ?? 0
        self.loanPurpose = request.loanPurpose ?? 0
        self.loanPurposeComment = request.loanPurposeComment ?? ""
        self.loanAmount = request.loanAmount ?? 0
        self.loanTerm = request.loanTerm ?? 0
        self.loanCurrency = request.loanCurrency ?? 0
        self.paymentType = request.paymentType ?? 0
        self.gracePeriod = request.gracePeriod ?? 0
        self.loanPercentage = request.loanPercentage ?? 0
        self.refereesInfo = request.refereesInfo ?? [RefereesInfoModel(name: "", phone: "", relation: "")]
        self.stepFirst = request.stepFirst ?? false
        self.stepSecond = request.stepSecond ?? false
        self.stepThird = request.stepThird ?? false
        self.stepFive = request.stepFive ?? false
        self.state = request.state ?? ""
        self.files = request.files ?? ["": ""]
        self.createdBy = request.createdBy ?? 0
        self.filledSteps = request.filledSteps ?? 0
        self.cftMessage = request.cftMessage ?? ""
        self.clientMainPhoneNum = request.clientMainPhoneNum ?? ""
    }
}

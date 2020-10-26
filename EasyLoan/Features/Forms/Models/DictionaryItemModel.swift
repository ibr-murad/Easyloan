//
//  DictionaryItemModel.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/26/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct DictionaryItemModel: Codable {
    var id: Int
    var name: String
    var parentID: String?
    var archive: Bool
}

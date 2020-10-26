//
//  DictionaryListModel.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/26/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

struct DictionaryListModel: Codable {
    var name: String
    var version: Int
    var items: [DictionaryItemModel]
}

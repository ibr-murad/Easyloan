//
//  UserDeafaults+Ex.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/27/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setLoggedInUser(user: UserModel) {
        set(true, forKey: "isLoggedIn")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            set(encoded, forKey: "user")
        }
        synchronize()
    }
    
    func setLoggedOutUser() {
        set(false, forKey: "isLoggedIn")
        removeObject(forKey: "user")
        synchronize()
    }

    func isLoggedIn() -> Bool {
        synchronize()
        return bool(forKey: "isLoggedIn")
    }
    
    
    func getUser() -> UserModel {
        if let savedUser = object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(UserModel.self, from: savedUser) {
                return user
            }
        }
        return UserModel(token: "", user: User(id: 0, cftId: 0, fullName: "nil", phoneNumber: "nil",
                                               departName: "nil", departCode: "nil", appAccess: 0))
    }
    
    func setDictionaryList(list: [DictionaryListModel]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(list) {
            set(encoded, forKey: "dictionaryList")
        }
        synchronize()
    }
    
    func getDictionaryByName(name: DictionaryNames) -> [DictionaryItemModel] {
        var list: [DictionaryItemModel] = []
        if let savedUser = object(forKey: "dictionaryList") as? Data {
            let decoder = JSONDecoder()
            if let decodedList = try? decoder.decode([DictionaryListModel].self, from: savedUser) {
                for item in decodedList {
                    if item.name == name.rawValue {
                        list = item.items
                    }
                }
            }
        }
        return list
    }
    
    func setFcmToken(token: String) {
        set(token, forKey: "fcmToken")
        synchronize()
    }
    
    func getFcmToken() -> String {
        guard let token = value(forKey: "fcmToken") as? String else {
            synchronize()
            return ""
        }
        synchronize()
        return token
    }
    
    func isNeedNotifications() -> Bool {
        synchronize()
        return bool(forKey: "isNeedNotifications")
    }
}

//
//  User.swift
//  TwitchTest
//
//  Created by t19960804 on 1/16/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation


class User{
    var account: String?
    var imageURL: String?
    var userName: String?
    var followers: [String]?
    
    init(value: [String : Any]) {
        self.account = value["account"] as? String
        self.imageURL = value["imageURL"] as? String
        self.userName = value["userName"] as? String
        self.followers = value["followers"] as? [String]
    }
}

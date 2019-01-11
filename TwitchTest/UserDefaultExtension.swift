//
//  UserDefaultExtension.swift
//  TwitchTest
//
//  Created by t19960804 on 1/11/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
extension UserDefaults{
    func isLogIn() -> Bool{
        return UserDefaults.standard.bool(forKey: UserDefaultsForKey.isLogIn.rawValue)
    }
    func setIsLogIn(value: Bool){
        UserDefaults.standard.set(value, forKey: UserDefaultsForKey.isLogIn.rawValue)
        UserDefaults.standard.synchronize()
    }
}
//要使用rawValue就要宣告型別
enum UserDefaultsForKey: String{
    case isLogIn
}

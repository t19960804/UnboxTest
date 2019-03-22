//
//  RegistrationViewModel.swift
//  TwitchTest
//
//  Created by t19960804 on 3/22/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation

class RegistrationViewModel {
    var account: String?{
        didSet{
            test()
        }
    }
    var password: String?{
        didSet{
            test()
        }
    }
    var userName: String?{
        didSet{
            test()
        }
    }
    func test(){
        print("account:\(account)")
        print("pswd:\(password)")
        print("userName:\(userName)")
    }
}

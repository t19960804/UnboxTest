//
//  LoginViewModel.swift
//  TwitchTest
//
//  Created by t19960804 on 3/23/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import Firebase

class LoginViewModel {
    var account: String?
    var password: String?
    var isLogining: Bool?{
        didSet{
            isLoginingObserver?(isLogining)
        }
    }
    var isLoginingObserver: ((Bool?) -> Void)?
    func performLogin(completion: @escaping (Error?) -> Void){
        guard let account = self.account,let password = self.password else {return}
        self.isLogining = true
        
        if account.isEmpty || password.isEmpty{
            let customError = NSError(domain: "", code: 321, userInfo: [NSLocalizedDescriptionKey : "Please fill the field"])
            completion(customError)
        }else{
            Auth.auth().signIn(withEmail: account, password: password) { (result, error) in
                if let error = error{
                    completion(error)
                    return
                }else{
                    self.isLogining = false
                    UserDefaults.standard.setIsLogIn(value: true)
                    completion(nil)
                }
                
            }
        }

    }
}

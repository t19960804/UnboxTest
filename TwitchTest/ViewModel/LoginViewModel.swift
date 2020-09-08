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
    func performLogin(completion: @escaping (Result<String,Error>) -> Void){
        guard let account = self.account,let password = self.password else {
            let customError = NSError(domain: "", code: 321, userInfo: [NSLocalizedDescriptionKey : "Please fill the field"])
            completion(.failure(customError))
            return
        }
        Auth.auth().signIn(withEmail: account, password: password) { (result, error) in
            if let error = error{
                completion(.failure(error))
                return
            }
            UserDefaults.standard.setIsLogIn(value: true)
            completion(.success("Info - Login success"))
        }
    }
}

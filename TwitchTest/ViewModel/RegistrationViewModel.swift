//
//  RegistrationViewModel.swift
//  TwitchTest
//
//  Created by t19960804 on 3/22/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var isRegistering: Bool?{
        didSet{
            isRegisteringObserver?(isRegistering)
        }
    }
    var userImage: UIImage?{
        didSet{
            pickImageObserver?(userImage)
        }
    }
    var account: String?
    var password: String?
    var userName: String?
    
    var pickImageObserver: ((UIImage?) -> Void)?
    var isRegisteringObserver: ((Bool?) -> Void)?
}

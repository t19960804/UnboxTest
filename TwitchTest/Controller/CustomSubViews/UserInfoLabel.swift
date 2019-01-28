//
//  UserInfoLabel.swift
//  TwitchTest
//
//  Created by t19960804 on 1/24/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit

class UserInfoLabel: UILabel {
    init(content: String,fontSize: UIFont,textColor: UIColor) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = content
        self.textColor = textColor
        self.font = fontSize
        self.isUserInteractionEnabled = true
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

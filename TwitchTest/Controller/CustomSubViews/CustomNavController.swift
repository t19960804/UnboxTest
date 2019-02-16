//
//  CustomNavController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/24/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit

class CustomNavController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.specialWhite]
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  JGProgressHUD.swift
//  TwitchTest
//
//  Created by t19960804 on 3/31/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import JGProgressHUD

extension JGProgressHUD{
    static func showErrorHUD(in view: UIView,detail: String){
        let errorHUD = JGProgressHUD(style: .dark)
        errorHUD.textLabel.text = "錯誤"
        errorHUD.detailTextLabel.text = detail
        errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
        errorHUD.show(in: view, animated: true)
        errorHUD.dismiss(afterDelay: 3, animated: true)
    }
}

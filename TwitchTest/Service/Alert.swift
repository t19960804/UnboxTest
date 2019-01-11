//
//  Alert.swift
//  TwitchTest
//
//  Created by t19960804 on 1/11/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit
struct Alert {
    
    var message: String
    var title: String
    var controller =  UIViewController()
    
    init(message: String , title: String , with controller: UIViewController) {
        self.message = message
        self.title = title
        self.controller = controller
    }
    func alert_InterNet(){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        let action = UIAlertAction(title: "知道了", style: .default) { (UIAlertAction) in
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    func alert_BugReport(){
        let alert = UIAlertController(title: title,message: message,preferredStyle: .alert)
        let action = UIAlertAction(title: "知道了",style: .default,handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.controller.present(alert,animated: true,completion: nil)
        }
    }
}

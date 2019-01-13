//
//  Alert2.swift
//  TwitchTest
//
//  Created by t19960804 on 1/13/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit
struct Alert {
    
    
    static func alert_InterNet(message: String , title: String , with controller: UIViewController){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        let action = UIAlertAction(title: "知道了", style: .default) { (UIAlertAction) in
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    static func alert_BugReport(message: String , title: String , with controller: UIViewController){
        let alert = UIAlertController(title: title,message: message,preferredStyle: .alert)
        let action = UIAlertAction(title: "知道了",style: .default,handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            controller.present(alert,animated: true,completion: nil)
        }
    }
}

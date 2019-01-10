//
//  File.swift
//  TwitchTest
//
//  Created by t19960804 on 2019/1/9.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class InternetService{
    static let internetService = InternetService()
    
    private init(){
        
    }
    
//    func getDataFromURL(url: String,values: [String : Any]?,completion: @escaping (JSON) -> Void){
//        Alamofire.request(url, method: .get, parameters: values).responseJSON { (response) in
//            if response.result.isSuccess{
//                let json = JSON(response.result.value as Any)
//                completion(json)
//            }
//        }
//    }
    func getDataFromURL(url: String,completion: @escaping (JSON) -> Void){
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                let json = JSON(response.result.value as Any)
                completion(json)
            }
        }
    }
}

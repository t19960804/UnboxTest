//
//  RegistrationViewModel.swift
//  TwitchTest
//
//  Created by t19960804 on 3/22/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import Firebase
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
    
    
    func performRegister(completion: @escaping (Result<[String : Any],Error>) -> Void){
        guard let account = account,let password = password,let userName = userName else{return}        
        if userName.isEmpty{
            let emptyError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey : "Please fill the empty field"])
            completion(.failure(emptyError))
            return
        }
        
        if let _ = userImage{
            Auth.auth().createUser(withEmail: account, password: password) { (result, error) in
                if let error = error{
                    completion(.failure(error))
                    return
                }
                guard let userUID = result?.user.uid else{ return }
                self.saveImageAndUserInfo(completion: completion, with: userUID,userName,account)
            }
        }else{
            let emptyError = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey : "Please choose a Image"])
            completion(.failure(emptyError))
        }
        
        
        
    }
    fileprivate func saveImageAndUserInfo(completion: @escaping (Result<[String : Any],Error>) -> Void,with userUID: String,_ userName: String,_ account: String){
        let imageUID = NSUUID().uuidString
        guard let userImage = self.userImage?.jpegData(compressionQuality: 0.2) else{return}
        //圖片存進Storage,再從裡面抓出URL
        let imageRef = Storage.storage().reference().child("userImages").child(imageUID)
        imageRef.putData(userImage, metadata: nil, completion: { (metadata, error) in
            if let error = error{
                completion(.failure(error))
                return
            }
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error{
                    completion(.failure(error))
                    return
                }
                let values: [String : Any] = ["uid" : userUID,
                                              "userName" : userName,
                                              "account" : account,
                                              "imageURL" : url?.absoluteString as Any]
                completion(.success(values))
            })
            
        })
        
    }
    
}

//
//  RealTimeDataBase.swift
//  TwitchTest
//
//  Created by t19960804 on 3/31/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import Firebase

extension Database{
    //抓取文章
    func fetchAllArticles(with category: String,completion: @escaping (Error?,Article?) -> Void){
        let ref = Database.database().reference()
        ref.child("類別").child(category).observe(.childAdded, with: { (snapshot) in
            //取得文章的UID,透過UID尋找文章
            let articleUID = snapshot.key
            ref.child("文章").child(articleUID).observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as! [String : Any]
                var article = Article(value: dictionary)
                let author = dictionary["authorUID"] as! String
                //透過文章中的author找尋作者資料
                ref.child("使用者").child(author).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary = snapshot.value as! [String : Any]
                    let user = User(value: dictionary)
                    article.author = user
                    completion(nil,article)
                })
            })
            
        })
    }
    //觀察使用者上傳新頭貼之後做更新
    func observeUserImageChanged(completion: @escaping (String) -> Void){
        let ref = Database.database().reference()
        guard let userUID = Auth.auth().currentUser?.uid else{return}
        ref.child("使用者").child(userUID).child("imageURL").observe(.value) { (snapshot) in
            if let url = snapshot.value as? String{
                completion(url)
            }
        }
    }
}

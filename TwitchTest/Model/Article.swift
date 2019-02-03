//
//  Article.swift
//  TwitchTest
//
//  Created by t19960804 on 1/14/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import SwiftyJSON
import FirebaseDatabase
import FirebaseAuth

struct Article {
    var author: User?
    var authorUID: String?
    var imageURL: String?
    var title: String?
    var review: String?
    var numberOfHeart: String?
    var date: String?
    
    init(value: [String : Any]) {
        self.imageURL = value["imageURL"] as? String
        self.title = value["title"] as? String
        self.review = value["review"] as? String
        self.numberOfHeart = value["numberOfHeart"] as? String
        self.date = value["date"] as? String
        self.authorUID = value["authorUID"] as? String
    }
    
    
}

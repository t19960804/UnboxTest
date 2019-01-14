//
//  Article.swift
//  TwitchTest
//
//  Created by t19960804 on 1/14/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import SwiftyJSON

class Article {
    var imageURL: String?
    var title: String?
    
    init(value: [String : Any]) {
        self.imageURL = value["imageURL"] as? String
        self.title = value["title"] as? String
    }
}

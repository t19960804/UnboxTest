//
//  Comment.swift
//  TwitchTest
//
//  Created by t19960804 on 3/1/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit

struct Comment {
    var comment: String?
    var authorUID: String?
    var author: User?
    init(value: [String : Any]) {
        self.comment = value["comment"] as? String
        self.authorUID = value["authorUID"] as? String
    }
}

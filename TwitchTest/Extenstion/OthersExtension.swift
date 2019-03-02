//
//  OthersExtension.swift
//  TwitchTest
//
//  Created by t19960804 on 3/2/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit

extension Date{
    static func getTimeStamp() -> String{
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        let dateNow = dateFormat.string(from: date)
        return dateNow
    }
}

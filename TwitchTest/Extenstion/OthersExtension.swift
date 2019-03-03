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
    static func stringToDate(dateString: String) -> Date{
        let dateFormatter = DateFormatter()
        //格式要對應傳進來的String,一定要有格式
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    //計算間距並獲取時間成分
    static func secondsBetweenDates(fromDate: Date,toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.second], from: fromDate,to: toDate)
        return components.second ?? 0
    }
    static func secondsTransForm(seconds: Int) -> String{
        //以秒數去比較
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        if seconds < minute{
            return "\(seconds)秒鐘前"
        }else if seconds < hour{
            return "\(seconds / minute)分鐘前"
        }else if seconds < day{
            return "\(seconds / hour)小時前"
        }else if seconds < week{
            return "\(seconds / day)天前"
        }else if seconds < month{
            return "\(seconds / week)星期前"
        }else if seconds < year{
            return "\(seconds / month)月前"
        }else{
            return "\(seconds / year)年前" 
        }
    }
}

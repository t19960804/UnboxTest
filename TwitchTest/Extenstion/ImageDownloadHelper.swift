//
//  ImageDownloadHelper.swift
//  TwitchTest
//
//  Created by t19960804 on 1/15/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    //夾帶著request出去的行為稱為task，也就是一項一項的任務
    //URLSession.shared來建立URLSession的singleton實例，透過這個實例，使用dataTask with reuqest函數來獲取data, response, error
    //因為這個連線必須手動執行，所以在設置完後必須接著使用方法resume()來送出連線。
    
    //當tableView不斷的deque時,圖片會被載入多次,造成資源浪費,改存在cache
    func downLoadImageInCache(downLoadURL: URL){
        //因為reuse cell的關係,之前cell的圖片也會出現在之後的cell,才會開始刷新圖片
        self.image = nil
        //如果能從cache撈出資料就直接給圖片,不行的話再去抓
        //透過Key取值
        if let imageFromCache = imageCache.object(forKey: downLoadURL as AnyObject) as? UIImage{
            
            self.image = imageFromCache
            return
        }else{
            URLSession.shared.dataTask(with: downLoadURL) { (data, response, error) in
                if let error = error{
                    print(error)
                    return
                }
                guard let data = data else{return}
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                    //透過Key存值
                    imageCache.setObject(self.image!, forKey: downLoadURL as Any as AnyObject)
                }
                }.resume()
        }
        
    }
}

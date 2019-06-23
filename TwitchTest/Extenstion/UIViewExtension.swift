//
//  UIViewExtension.swift
//  TwitchTest
//
//  Created by t19960804 on 6/23/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

extension UIView {
    func addSubViews(with subviews: UIView...){
        subviews.forEach{self.addSubview($0)}
    }
}

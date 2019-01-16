//
//  loveImageView.swift
//  TwitchTest
//
//  Created by t19960804 on 1/14/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit

class LoveImageView: UIImageView {
    
    init(tintColor: UIColor){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = UIImage(named: "like512")?.withRenderingMode(.alwaysTemplate)
        self.tintColor = tintColor
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

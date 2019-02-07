//
//  ArticleDetailCell.swift
//  TwitchTest
//
//  Created by t19960804 on 2/7/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit

class ArticleDetailCell: UICollectionViewCell {
    let commodityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(commodityImageView)
        commodityImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        commodityImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        commodityImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        commodityImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

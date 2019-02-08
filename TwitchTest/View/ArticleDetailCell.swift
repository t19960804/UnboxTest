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
    
    var imageURL: String?{
        didSet{
            if let imageURL = imageURL{
                commodityImageView.downLoadImageInCache(downLoadURL: URL(string: imageURL)!)

            }
        }
    }
    let background_commodityImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor(red: 120/255, green: 121/255, blue: 122/255, alpha: 1.0).cgColor
        view.layer.shadowOpacity = 0.7
        return view
    }()
    
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
        self.addSubview(background_commodityImageView)
        background_commodityImageView.addSubview(commodityImageView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 40)
        gradientLayer.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
        commodityImageView.layer.insertSublayer(gradientLayer, at: 0)
        
        
        background_commodityImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        background_commodityImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        background_commodityImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.95).isActive = true
        

        commodityImageView.topAnchor.constraint(equalTo: background_commodityImageView.topAnchor).isActive = true
        commodityImageView.leftAnchor.constraint(equalTo: background_commodityImageView.leftAnchor).isActive = true
        commodityImageView.rightAnchor.constraint(equalTo: background_commodityImageView.rightAnchor).isActive = true
        commodityImageView.bottomAnchor.constraint(equalTo: background_commodityImageView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

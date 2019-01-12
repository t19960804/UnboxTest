//
//  AllGamesCell.swift
//  TwitchTest
//
//  Created by t19960804 on 2019/1/9.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit



class CategoryCell: UICollectionViewCell {
    
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.tintColor = themeGrayColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = themeGrayColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(categoryImageView)
        self.addSubview(categoryLabel)
        
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        
        self.backgroundColor = specialYellow
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        setUpConstraints()
    }
    func setUpConstraints(){
        
        
        categoryImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 8).isActive = true
        categoryImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75).isActive = true
        categoryImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        categoryImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
        
        categoryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor, constant: 9).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

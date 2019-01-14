//
//  ArticlesCell.swift
//  TwitchTest
//
//  Created by t19960804 on 1/12/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit

class ArticlesCell: UICollectionViewCell {
    let commodityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = specialGray
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "unbox")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = themeGrayColor
        imageView.layer.cornerRadius = ((self.frame.height * 0.3) - 21) / 2
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "AsiaGodTone")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = themeGrayColor.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    let commodityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "標題:華碩電競桌機開箱"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = themeGrayColor
        return label
    }()
    let loveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "推薦程度:"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = themeGrayColor
        return label
    }()
    let loveImageView = LoveImageView(tintColor: heartPink)

    let checkButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("查看", for: .normal)
        button.setTitleColor(specialYellow, for: .normal)
        button.backgroundColor = themeGrayColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(commodityImageView)
        self.addSubview(userImageView)
        self.addSubview(commodityNameLabel)
        self.addSubview(loveLabel)
        self.addSubview(loveImageView)
        self.addSubview(checkButton)
        
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
        commodityImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        commodityImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        commodityImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        commodityImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7).isActive = true
        
        userImageView.topAnchor.constraint(equalTo: commodityImageView.bottomAnchor, constant: 8).isActive = true
        userImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        userImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3, constant: -21).isActive = true
        userImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3, constant: -21).isActive = true
        
        commodityNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: 8).isActive = true
        commodityNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true
        commodityNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
        loveLabel.topAnchor.constraint(equalTo: commodityNameLabel.bottomAnchor, constant: 8).isActive = true
        loveLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true
        
        loveImageView.topAnchor.constraint(equalTo: loveLabel.topAnchor).isActive = true
        loveImageView.leftAnchor.constraint(equalTo: loveLabel.rightAnchor, constant: 4).isActive = true
        loveImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        loveImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        checkButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        checkButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        checkButton.topAnchor.constraint(equalTo: loveLabel.topAnchor).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

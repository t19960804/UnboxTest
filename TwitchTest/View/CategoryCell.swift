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
    var category: String?{
        didSet{
            self.categoryImageView.image = UIImage(named: category!)?.withRenderingMode(.alwaysTemplate)
            self.categoryLabel.text = category
        }
    }
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.tintColor = .specialWhite
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .specialWhite
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(categoryImageView)
        self.addSubview(categoryLabel)
        
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        
        self.backgroundColor = UIColor.themePink
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.shadowGray.cgColor

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

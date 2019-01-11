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
    
    lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        //超出範圍的切掉
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = specialYellow
        return imageView
    }()
    let background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 8
        view.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(background)
        background.addSubview(categoryImageView)
        setUpConstraints()
    }
    func setUpConstraints(){
        background.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        
        categoryImageView.topAnchor.constraint(equalTo: background.topAnchor).isActive = true
        categoryImageView.bottomAnchor.constraint(equalTo: background.bottomAnchor).isActive = true
        categoryImageView.rightAnchor.constraint(equalTo: background.rightAnchor).isActive = true
        categoryImageView.leftAnchor.constraint(equalTo: background.leftAnchor).isActive = true
        
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

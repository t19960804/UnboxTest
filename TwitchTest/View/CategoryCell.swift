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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageViewClicked))
        imageView.addGestureRecognizer(tapGesture)
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    let background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 8
//        view.layer.masksToBounds = true
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 8
        view.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        return view
    }()
    let foreground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return view
    }()
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.alpha = 0
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(background)
        background.addSubview(categoryImageView)
        self.addSubview(foreground)
        self.addSubview(categoryLabel)
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
        
        foreground.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        foreground.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        foreground.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        foreground.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true

        categoryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

    }
    @objc func handleImageViewClicked(){
        foreground.alpha = 1
        categoryLabel.alpha = 1
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
            self.foreground.alpha = 0
            self.categoryLabel.alpha = 0
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
                
            }, completion: nil)
        }, completion: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

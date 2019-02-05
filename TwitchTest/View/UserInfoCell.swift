//
//  UserInfoCell.swift
//  TwitchTest
//
//  Created by t19960804 on 1/25/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol UserInfoCell_Delegate {
    func showDeleteAlert(article: Article)
}

class UserInfoCell: UICollectionViewCell {
    var delegate: UserInfoCell_Delegate?
    var loveImageViewArray = [UIImageView]()
    let currentUser = Auth.auth().currentUser?.uid
    var article: Article?{
        didSet{
            if let imageURL = article?.imageURL,let title = article?.title,let numbersOfHeart = article?.numberOfHeart,let authorUID = article?.authorUID{
                self.commodityImageView.downLoadImageInCache(downLoadURL: URL(string: imageURL)!)
                commodityNameLabel.text = title
                lightUpTheHearts(number: Int(numbersOfHeart) ?? 1)
                deleteButton.isHidden = authorUID == currentUser ? false : true
            }
        }
    }
    let background_commodityImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowColor = specialGray2.cgColor
        return view
    }()
    let commodityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = specialWhite
        return imageView
    }()
    let commodityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "這只是測試這只是測試這只是測試這只是測試這只是測試"
        label.textColor = specialWhite
        return label
    }()
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "rubbish-bin2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDeleteArticle), for: .touchUpInside)
        return button
    }()
    let loveImageView_1 = LoveImageView(tintColor: themeColor)
    let loveImageView_2 = LoveImageView(tintColor: themeColor)
    let loveImageView_3 = LoveImageView(tintColor: themeColor)
    let loveImageView_4 = LoveImageView(tintColor: themeColor)
    let loveImageView_5 = LoveImageView(tintColor: themeColor)
    
    
    lazy var loveImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(loveImageView_1)
        stackView.addArrangedSubview(loveImageView_2)
        stackView.addArrangedSubview(loveImageView_3)
        stackView.addArrangedSubview(loveImageView_4)
        stackView.addArrangedSubview(loveImageView_5)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        self.addSubview(background_commodityImageView)
        background_commodityImageView.addSubview(commodityImageView)
        self.addSubview(commodityNameLabel)
        self.addSubview(loveImageStackView)
        self.addSubview(deleteButton)
        
        loveImageViewArray.append(loveImageView_1)
        loveImageViewArray.append(loveImageView_2)
        loveImageViewArray.append(loveImageView_3)
        loveImageViewArray.append(loveImageView_4)
        loveImageViewArray.append(loveImageView_5)
        
        setUpConstraints()
    }
    func setUpConstraints(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
        gradientLayer.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
        commodityImageView.layer.insertSublayer(gradientLayer, at: 0)
        
        background_commodityImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        background_commodityImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        background_commodityImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        background_commodityImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        commodityImageView.topAnchor.constraint(equalTo: background_commodityImageView.topAnchor).isActive = true
        commodityImageView.leftAnchor.constraint(equalTo: background_commodityImageView.leftAnchor).isActive = true
        commodityImageView.bottomAnchor.constraint(equalTo: background_commodityImageView.bottomAnchor).isActive = true
        commodityImageView.rightAnchor.constraint(equalTo: background_commodityImageView.rightAnchor).isActive = true

        commodityNameLabel.topAnchor.constraint(equalTo: commodityImageView.topAnchor, constant: 8).isActive = true
        commodityNameLabel.leftAnchor.constraint(equalTo: commodityImageView.leftAnchor, constant: 8).isActive = true
        commodityNameLabel.widthAnchor.constraint(equalTo: commodityImageView.widthAnchor, multiplier: 0.7).isActive = true
        
        loveImageStackView.leftAnchor.constraint(equalTo: commodityNameLabel.leftAnchor).isActive = true
        loveImageStackView.bottomAnchor.constraint(equalTo: commodityImageView.bottomAnchor, constant: -8).isActive = true
        loveImageStackView.heightAnchor.constraint(equalTo: commodityImageView.heightAnchor, multiplier: 0.1).isActive = true
        loveImageStackView.widthAnchor.constraint(equalTo: commodityImageView.widthAnchor, multiplier: 0.25).isActive = true
        
        deleteButton.rightAnchor.constraint(equalTo: commodityImageView.rightAnchor, constant: -8).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: loveImageStackView.bottomAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func lightUpTheHearts(number: Int){
        for i in 0...loveImageViewArray.count - 1{
            if i >= number{
                loveImageViewArray[i].tintColor = specialGray
            }
        }
    }
    
    @objc func handleDeleteArticle(){
        if let article = article{
            delegate?.showDeleteAlert(article: article)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

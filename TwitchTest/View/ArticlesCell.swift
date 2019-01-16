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
    var loveImageViewArray = [LoveImageView]()
    var article: Article?{
        didSet{
            if let title = article?.title,let imageURL = article?.imageURL,let numberOfHearts = article?.numberOfHeart{
                self.commodityNameLabel.text = "標題:\(title)"
                self.commodityImageView.downLoadImageInCache(downLoadURL: URL(string: imageURL)!)
                lightUpTheHearts(number: Int(numberOfHearts)!)
            }
            
        }
    }
    
    var user: User?{
        didSet{
            if let imageURL = user?.imageURL{
                self.userImageView.downLoadImageInCache(downLoadURL: URL(string: imageURL)!)
            }
        }
    }
    let commodityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = specialWhite
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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = themeGrayColor.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    let commodityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
    let loveImageView_1 = LoveImageView(tintColor: heartPink)
    let loveImageView_2 = LoveImageView(tintColor: heartPink)
    let loveImageView_3 = LoveImageView(tintColor: heartPink)
    let loveImageView_4 = LoveImageView(tintColor: heartPink)
    let loveImageView_5 = LoveImageView(tintColor: heartPink)
    
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
        
        loveImageViewArray.append(loveImageView_1)
        loveImageViewArray.append(loveImageView_2)
        loveImageViewArray.append(loveImageView_3)
        loveImageViewArray.append(loveImageView_4)
        loveImageViewArray.append(loveImageView_5)

        
        self.addSubview(commodityImageView)
        self.addSubview(userImageView)
        self.addSubview(commodityNameLabel)
        self.addSubview(loveLabel)
        self.addSubview(loveImageStackView)
        
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
    func lightUpTheHearts(number: Int){
        for i in 0...loveImageViewArray.count - 1{
            if i >= number{
                loveImageViewArray[i].tintColor = UIColor.clear
            }
        }
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
        
        commodityNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: 4).isActive = true
        commodityNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true
        commodityNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
        loveLabel.topAnchor.constraint(equalTo: commodityNameLabel.bottomAnchor, constant: 6).isActive = true
        loveLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true
        
        loveImageStackView.topAnchor.constraint(equalTo: loveLabel.topAnchor).isActive = true
        loveImageStackView.leftAnchor.constraint(equalTo: loveLabel.rightAnchor, constant: 5).isActive = true
        loveImageStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        loveImageStackView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

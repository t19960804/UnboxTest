//
//  ArticlesCell.swift
//  TwitchTest
//
//  Created by t19960804 on 1/12/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit


protocol ArticleCellDelegate: class {
    func pushToArticleDetail(article: Article)
}

class ArticlesCell: UICollectionViewCell {
    var loveImageViewArray = [LoveImageView]()
    weak var delegate: ArticleCellDelegate?
    
    
    var article: Article?{
        didSet{
            if let title = article?.title,let imageURL = article?.imageURL,let numberOfHearts = article?.numberOfHeart,let userImageURL = article?.author?.imageURL,let review = article?.review,let userName = article?.author?.userName{
                self.commodityNameLabel.text = title
                self.commodityImageView.downLoadImageInCache(downLoadURL: URL(string: imageURL)!)
                self.userImageView.downLoadImageInCache(downLoadURL: URL(string: userImageURL)!)
                self.reviewTextView.text = review
                self.userNameLabel.text = userName
                lightUpTheHearts(number: Int(numberOfHearts) ?? 1)
            }
            
        }
    }
    let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = specialWhite
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 2

        view.layer.shadowOpacity = 0.7
        view.layer.shadowColor = shadowGray.cgColor
        return view
    }()
    let background_commodityImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.7
        view.layer.shadowColor = shadowGray.cgColor
        return view
    }()
    let commodityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = specialWhite
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = ((self.frame.height * 0.2) - 21) / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        return label
    }()
    let commodityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = specialWhite
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = specialWhite
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()

    lazy var checkButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("查看", for: UIControl.State.normal)
        button.setTitleColor(specialWhite, for: UIControl.State.normal)
        button.backgroundColor = themeColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleCheckCommodity), for: .touchUpInside)
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

        loveImageViewArray.append(loveImageView_1)
        loveImageViewArray.append(loveImageView_2)
        loveImageViewArray.append(loveImageView_3)
        loveImageViewArray.append(loveImageView_4)
        loveImageViewArray.append(loveImageView_5)


        self.addSubview(backView)
        self.addSubview(background_commodityImageView)
        self.addSubview(commodityImageView)
        self.addSubview(userImageView)
        self.addSubview(userNameLabel)
        self.addSubview(loveImageStackView)
        self.addSubview(commodityNameLabel)
        self.addSubview(reviewTextView)
        self.addSubview(checkButton)
        
        setUpConstraints()
        
        
    }
    @objc func handleCheckCommodity(){
        if let article = article{
            self.delegate?.pushToArticleDetail(article: article)
        }
    }
    func lightUpTheHearts(number: Int){
        for i in 0...loveImageViewArray.count - 1{
            if i >= number{
                loveImageViewArray[i].tintColor = specialGray
            }
        }
    }
    func setUpConstraints(){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.45, height: 40)
        gradientLayer.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
        commodityImageView.layer.insertSublayer(gradientLayer, at: 0)
        
        backView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        backView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        backView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        backView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true

        background_commodityImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        background_commodityImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        background_commodityImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7).isActive = true
        background_commodityImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45).isActive = true
        
        commodityImageView.topAnchor.constraint(equalTo: background_commodityImageView.topAnchor).isActive = true
        commodityImageView.leftAnchor.constraint(equalTo: background_commodityImageView.leftAnchor).isActive = true
        commodityImageView.heightAnchor.constraint(equalTo: background_commodityImageView.heightAnchor).isActive = true
        commodityImageView.widthAnchor.constraint(equalTo: background_commodityImageView.widthAnchor).isActive = true

        userImageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12).isActive = true
        userImageView.leftAnchor.constraint(equalTo: commodityImageView.rightAnchor, constant: 12).isActive = true
        userImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2, constant: -21).isActive = true
        userImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2, constant: -21).isActive = true
        
        userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -8).isActive = true
        
        commodityNameLabel.topAnchor.constraint(equalTo: commodityImageView.topAnchor, constant: 0).isActive = true
        commodityNameLabel.leftAnchor.constraint(equalTo: commodityImageView.leftAnchor, constant: 7).isActive = true
        commodityNameLabel.rightAnchor.constraint(equalTo: commodityImageView.rightAnchor, constant: -7).isActive = true
        commodityNameLabel.heightAnchor.constraint(equalTo: commodityImageView.heightAnchor, multiplier: 0.15).isActive = true
        
        loveImageStackView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 7).isActive = true
        loveImageStackView.leftAnchor.constraint(equalTo: userImageView.leftAnchor).isActive = true
        loveImageStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        loveImageStackView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        reviewTextView.topAnchor.constraint(equalTo: loveImageStackView.bottomAnchor, constant: 8).isActive = true
        reviewTextView.leftAnchor.constraint(equalTo: userImageView.leftAnchor).isActive = true
        reviewTextView.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -8).isActive = true
        reviewTextView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        checkButton.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: 7).isActive = true
        checkButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -7).isActive = true
        checkButton.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 7).isActive = true
        checkButton.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -7).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

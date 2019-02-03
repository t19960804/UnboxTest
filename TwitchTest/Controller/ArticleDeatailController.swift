//
//  ArticleDeatailController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/17/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit


class ArticleDeatailController: UIViewController {
    var reviewTextViewHeightAnchor: NSLayoutConstraint?
    var article: Article?{
        didSet{
            if let imageURl = article?.imageURL,let title = article?.title,let userImageURL = article?.author?.imageURL,
                let userName = article?.author?.userName,let review = article?.review{
                commodityImageView.downLoadImageInCache(downLoadURL: URL(string: imageURl)!)
                userImageView.downLoadImageInCache(downLoadURL: URL(string: userImageURL)!)
//                titleLabel.text = title
                userNameLabel.text = userName
                reviewTextView.text = review
            }
        }
    }
    lazy var halfViewHeight = self.view.frame.height / 2
    lazy var myScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame:self.view.frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width:self.view.frame.width , height: halfViewHeight + estimateTextViewFrame(string: reviewTextView.text, fontSize: UIFont.systemFont(ofSize: 20)).height + 80)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    let backGroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    ////////////////////////////
    var loveImageViewArray = [UIImageView]()
    let background_commodityImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor(red: 120/255, green: 121/255, blue: 122/255, alpha: 1.0).cgColor
        view.layer.shadowOpacity = 0.7
        return view
    }()
    let commodityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = specialWhite
        return label
    }()
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleToUserInfo))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = specialWhite
        return label
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
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = specialWhite
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.isEditable = false
        return textView
    }()

    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = themeColor
        button.setTitle("留言板", for: .normal)
        button.setTitleColor(specialWhite, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.7
        button.layer.shadowColor = shadowGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)


        return button
    }()
    override func viewWillAppear(_ animated: Bool) {
        lightUpTheHearts(number: Int((article?.numberOfHeart)!)!)
        reviewTextViewHeightAnchor?.constant = estimateTextViewFrame(string: reviewTextView.text, fontSize: UIFont.systemFont(ofSize: 20)).height + 20

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = specialWhite
        self.view.addSubview(myScrollView)
        self.navigationItem.title = "商品詳情"
        myScrollView.addSubview(backGroundView)
        
        backGroundView.addSubview(background_commodityImageView)
        background_commodityImageView.addSubview(commodityImageView)
        backGroundView.addSubview(commentButton)
        
        
        backGroundView.addSubview(titleLabel)
        backGroundView.addSubview(userImageView)
        backGroundView.addSubview(userNameLabel)
//        backGroundView.addSubview(loveImageStackView)
        backGroundView.addSubview(reviewTextView)
        
        
        
        loveImageViewArray.append(loveImageView_1)
        loveImageViewArray.append(loveImageView_2)
        loveImageViewArray.append(loveImageView_3)
        loveImageViewArray.append(loveImageView_4)
        loveImageViewArray.append(loveImageView_5)
        setUpConstraints()
       
    }
    @objc func handleToUserInfo(){
        let userInfoController = UserInfoController()
        userInfoController.user = article?.author
        self.navigationController?.pushViewController(userInfoController, animated: true)
    }
    
    //計算動態TextView高度
    func estimateTextViewFrame(string: String,fontSize: UIFont) -> CGRect{
        //size,限制的size,不然不知道哪裡換行
        //usesLineFragmentOrigin,文本将以每行组成的矩形为单位计算整个文本的尺寸
        //attributes,字體大小
        let constraintSize = CGSize(width: self.view.frame.width * 0.8, height: 1000)
        let estimateFrame = NSString(string: string).boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : fontSize], context: nil)
        return estimateFrame
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
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        gradientLayer.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
        commodityImageView.layer.insertSublayer(gradientLayer, at: 0)
        
        myScrollView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: safeAreaHeight_Top + 44).isActive = true
        myScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        myScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        myScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        backGroundView.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        backGroundView.heightAnchor.constraint(equalToConstant: halfViewHeight + estimateTextViewFrame(string: reviewTextView.text, fontSize: UIFont.systemFont(ofSize: 20)).height + 80 ).isActive = true
        backGroundView.topAnchor.constraint(equalTo: myScrollView.topAnchor).isActive = true
        backGroundView.centerXAnchor.constraint(equalTo: myScrollView.centerXAnchor).isActive = true
        
        background_commodityImageView.topAnchor.constraint(equalTo: backGroundView.topAnchor).isActive = true
        background_commodityImageView.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor).isActive = true
        background_commodityImageView.widthAnchor.constraint(equalTo: backGroundView.widthAnchor, multiplier: 0.8).isActive = true
        background_commodityImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.45).isActive = true
        
        commodityImageView.topAnchor.constraint(equalTo: background_commodityImageView.topAnchor).isActive = true
        commodityImageView.leftAnchor.constraint(equalTo: background_commodityImageView.leftAnchor).isActive = true
        commodityImageView.bottomAnchor.constraint(equalTo: background_commodityImageView.bottomAnchor).isActive = true
        commodityImageView.rightAnchor.constraint(equalTo: background_commodityImageView.rightAnchor).isActive = true

        

        titleLabel.leftAnchor.constraint(equalTo: commodityImageView.leftAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: commodityImageView.topAnchor, constant: 8).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: commodityImageView.widthAnchor, multiplier: 0.8).isActive = true

        userImageView.topAnchor.constraint(equalTo: commodityImageView.topAnchor, constant: 5).isActive = true
        userImageView.leftAnchor.constraint(equalTo: commodityImageView.leftAnchor, constant: 5).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true

        userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true

//        loveImageStackView.rightAnchor.constraint(equalTo: commodityImageView.rightAnchor, constant: -8).isActive = true
//        loveImageStackView.bottomAnchor.constraint(equalTo: commodityImageView.bottomAnchor, constant: -8).isActive = true
//        loveImageStackView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        loveImageStackView.heightAnchor.constraint(equalToConstant: 35).isActive = true

        
        reviewTextView.topAnchor.constraint(equalTo: commodityImageView.bottomAnchor, constant: 40).isActive = true
        reviewTextView.leftAnchor.constraint(equalTo: commodityImageView.leftAnchor).isActive = true
        reviewTextView.widthAnchor.constraint(equalTo: backGroundView.widthAnchor, multiplier: 0.85).isActive = true
        reviewTextViewHeightAnchor = reviewTextView.heightAnchor.constraint(equalToConstant: 200)
        reviewTextViewHeightAnchor?.isActive = true
        
        commentButton.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor).isActive = true
        commentButton.centerYAnchor.constraint(equalTo: commodityImageView.bottomAnchor).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        commentButton.widthAnchor.constraint(equalTo: backGroundView.widthAnchor, multiplier: 0.5).isActive = true
        
        

        
    }


}

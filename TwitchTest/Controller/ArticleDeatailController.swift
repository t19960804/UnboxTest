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
                titleLabel.text = title
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
    let commodityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        imageView.layer.cornerRadius = 35
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleToUserInfo))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        return label
    }()
    let loveImageView_1 = LoveImageView(tintColor: specialYellow)
    let loveImageView_2 = LoveImageView(tintColor: specialYellow)
    let loveImageView_3 = LoveImageView(tintColor: specialYellow)
    let loveImageView_4 = LoveImageView(tintColor: specialYellow)
    let loveImageView_5 = LoveImageView(tintColor: specialYellow)
    
    
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
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = specialYellow
        button.setTitle("留言板", for: UIControl.State.normal)
        button.setTitleColor(specialWhite, for: UIControl.State.normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    override func viewWillAppear(_ animated: Bool) {
        loveImageViewArray.append(loveImageView_1)
        loveImageViewArray.append(loveImageView_2)
        loveImageViewArray.append(loveImageView_3)
        loveImageViewArray.append(loveImageView_4)
        loveImageViewArray.append(loveImageView_5)
        
        lightUpTheHearts(number: Int((article?.numberOfHeart)!)!)
        
        reviewTextViewHeightAnchor?.constant = estimateTextViewFrame(string: reviewTextView.text, fontSize: UIFont.systemFont(ofSize: 20)).height + 20

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = specialWhite
        self.view.addSubview(myScrollView)
        self.navigationItem.title = "商品詳情"
        myScrollView.addSubview(backGroundView)
        backGroundView.addSubview(commodityImageView)
        backGroundView.addSubview(titleLabel)
        backGroundView.addSubview(userImageView)
        backGroundView.addSubview(userNameLabel)
        backGroundView.addSubview(loveImageStackView)
        backGroundView.addSubview(reviewTextView)
        backGroundView.addSubview(commentButton)
        
        setUpConstraints()
       
    }
    @objc func handleToUserInfo(){
        let userInfoController = UserInfoController()
        self.navigationController?.pushViewController(userInfoController, animated: true)
    }
    //計算動態TextView高度
    func estimateTextViewFrame(string: String,fontSize: UIFont) -> CGRect{
        //size,限制的size,不然不知道哪裡換行
        //usesLineFragmentOrigin,文本将以每行组成的矩形为单位计算整个文本的尺寸
        //attributes,字體大小
        let constraintSize = CGSize(width: self.view.frame.width * 0.9, height: 1000)
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
        
        myScrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        myScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        myScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        myScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        backGroundView.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        backGroundView.heightAnchor.constraint(equalToConstant: halfViewHeight + estimateTextViewFrame(string: reviewTextView.text, fontSize: UIFont.systemFont(ofSize: 20)).height + 80 ).isActive = true
        backGroundView.topAnchor.constraint(equalTo: myScrollView.topAnchor).isActive = true
        backGroundView.centerXAnchor.constraint(equalTo: myScrollView.centerXAnchor).isActive = true
        
        commodityImageView.topAnchor.constraint(equalTo: backGroundView.topAnchor).isActive = true
        commodityImageView.leftAnchor.constraint(equalTo: backGroundView.leftAnchor).isActive = true
        commodityImageView.rightAnchor.constraint(equalTo: backGroundView.rightAnchor).isActive = true
        commodityImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        titleLabel.leftAnchor.constraint(equalTo: commodityImageView.leftAnchor, constant: 8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: commodityImageView.bottomAnchor, constant: -8).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: commodityImageView.widthAnchor, multiplier: 0.8).isActive = true

        userImageView.topAnchor.constraint(equalTo: commodityImageView.bottomAnchor, constant: 10).isActive = true
        userImageView.leftAnchor.constraint(equalTo: commodityImageView.leftAnchor, constant: 10).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true

        userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true

        loveImageStackView.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        loveImageStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        loveImageStackView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loveImageStackView.heightAnchor.constraint(equalToConstant: 35).isActive = true

        
        reviewTextView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20).isActive = true
        reviewTextView.leftAnchor.constraint(equalTo: userImageView.leftAnchor).isActive = true
        reviewTextView.widthAnchor.constraint(equalTo: backGroundView.widthAnchor, multiplier: 0.95).isActive = true
        reviewTextViewHeightAnchor = reviewTextView.heightAnchor.constraint(equalToConstant: 200)
        reviewTextViewHeightAnchor?.isActive = true
        
        commentButton.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: 20).isActive = true
        commentButton.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        commentButton.widthAnchor.constraint(equalTo: backGroundView.widthAnchor, multiplier: 0.7).isActive = true
    }


}

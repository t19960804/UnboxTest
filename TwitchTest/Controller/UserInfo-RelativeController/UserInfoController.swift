//
//  UserInfoController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/23/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserInfoController: UIViewController {
    var article: Article?{
        didSet{
            if let userImageURL = article?.author?.imageURL,let userName = article?.author?.userName{
                userImageView.downLoadImageInCache(downLoadURL: URL(string: userImageURL)!)
                userNameLabel.text = userName
                
            }
        }
    }
    let cellID = "Cell"
    var articlesArray = [Article]()
    var timer: Timer?
    let ref = Database.database().reference()
    lazy var authorUID = article?.authorUID
    let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "beach")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 0.4)
        return view
    }()
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "AsiaGodTone")
        imageView.layer.cornerRadius = 75
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let userNameLabel = UserInfoLabel(content: "", fontSize: .boldSystemFont(ofSize: 18), textColor: specialWhite)
//    let messageLabel = UserInfoLabel(content: "尚無文章!", fontSize: .boldSystemFont(ofSize: 30), textColor: specialGray2)
    let follwerLabel = UserInfoLabel(content: "追蹤人數", fontSize: .boldSystemFont(ofSize: 18), textColor: specialWhite)
    let numberOfArticleLabel = UserInfoLabel(content: "文章數", fontSize: .boldSystemFont(ofSize: 18), textColor: specialWhite)
    let follwerNumberLabel = UserInfoLabel(content: "123", fontSize: .boldSystemFont(ofSize: 30), textColor: specialWhite)
    let articleNumberLabel = UserInfoLabel(content: "", fontSize: .boldSystemFont(ofSize: 30), textColor: specialWhite)
    lazy var stackView_Label: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(follwerLabel)
        stackView.addArrangedSubview(numberOfArticleLabel)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    let followerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("追蹤", for: .normal)
        button.setTitleColor(specialWhite, for: .normal)
        button.backgroundColor = specialCyan
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowColor = shadowGray.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 2
        return button
    }()
    lazy var stackView_Number: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(follwerNumberLabel)
        stackView.addArrangedSubview(articleNumberLabel)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNumbersOfArticle()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = specialWhite
        self.view.addSubview(backImageView)
        self.view.addSubview(backView)
        self.view.addSubview(userImageView)
        self.view.addSubview(userNameLabel)
        self.view.addSubview(stackView_Label)
        self.view.addSubview(stackView_Number)
        self.view.addSubview(followerButton)
        
        
        setUpNavBar()
        setUpConstraints()
        fetchArticles()
        buttonActionAdd()
        
    }
    func buttonActionAdd(){
        let tap = UITapGestureRecognizer(target: self, action:  #selector(handleCheckArticles))
        articleNumberLabel.addGestureRecognizer(tap)
    }
    func setUpNavBar(){
        self.navigationItem.title = "個人資料"
        let settingImg = UIImage(named: "settings2")
        let settingBarButton = UIBarButtonItem(image: settingImg, style: .plain, target: self, action: #selector(handleSetting))
        let isCurrentUser = article?.authorUID == Auth.auth().currentUser?.uid
        self.navigationItem.rightBarButtonItems = isCurrentUser ? [] : [settingBarButton]
        followerButton.isHidden = isCurrentUser ? true : false
    }
    @objc func handleCheckArticles(){
        let articlesController = ArticlesController(collectionViewLayout: UICollectionViewFlowLayout())
        articlesController.articlesArray = self.articlesArray
        self.navigationController?.pushViewController(articlesController, animated: true)
    }
    @objc func handleSetting(){
        print("set")
    }
    //監聽文章數的變化
    func fetchNumbersOfArticle(){
        ref.child("使用者").child(authorUID!).observe(.value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            if let numbersOfArticle = dictionary["numbersOfArticle"] as? Int{
                self.articleNumberLabel.text = String(numbersOfArticle)
            }
        }
       
    }
    //不能放ViewWillAppear,陣列會重複.append
    func fetchArticles(){
        ref.child("使用者-文章").child(authorUID!).observe(.childAdded) { (snapshot) in
            let articleUID = snapshot.key
            //用Key找文章
            self.ref.child("文章").child(articleUID).observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as! [String : Any]
                guard let authorUID = dictionary["authorUID"] as? String else{return}
                let article = Article(value: dictionary)
                self.ref.child("使用者").child(authorUID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary = snapshot.value as! [String : Any]
                    let user = User(value: dictionary)
                    article.author = user
                    self.articlesArray.append(article)
                    self.attemptReload()
                })
            })
        }
    }
    private func attemptReload(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
    }
    @objc func handleReload(){
        self.articlesArray.sort {$0.date! > $1.date!}
    }
    func setUpConstraints(){
        
        backImageView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 0).isActive = true
        backImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        backImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        backImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        
        
        backView.topAnchor.constraint(equalTo: backImageView.topAnchor).isActive = true
        backView.leftAnchor.constraint(equalTo: backImageView.leftAnchor).isActive = true
        backView.rightAnchor.constraint(equalTo: backImageView.rightAnchor).isActive = true
        backView.heightAnchor.constraint(equalTo: backImageView.heightAnchor).isActive = true
        
        userImageView.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
        userImageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: safeAreaHeight_Top + 44 + 40).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        userNameLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 8).isActive = true
        
        stackView_Label.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10).isActive = true
        stackView_Label.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
        stackView_Label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView_Label.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 1).isActive = true
        
        stackView_Number.topAnchor.constraint(equalTo: stackView_Label.bottomAnchor, constant: 10).isActive = true
        stackView_Number.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
        stackView_Number.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView_Number.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 1).isActive = true
        
        followerButton.centerYAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true
        followerButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
        followerButton.heightAnchor.constraint(equalTo: backView.heightAnchor, multiplier: 0.1).isActive = true
        followerButton.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 0.45).isActive = true
    }
}


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
    let userUID = Auth.auth().currentUser?.uid
    var result = Bool()
    
    let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "beach")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let gradient = CAGradientLayer()
        let color1 = UIColor(red: 237/255, green: 110/255, blue: 160/255, alpha: 1)
        let color2 = UIColor(red: 236/255, green: 140/255, blue: 105/255, alpha: 1)
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)

        gradient.colors = [color2.cgColor,color1.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.5)
        view.layer.addSublayer(gradient)
        return view
    }()
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "AsiaGodTone")
        imageView.layer.cornerRadius = 75
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = specialWhite.cgColor
        imageView.layer.borderWidth = 4
        return imageView
    }()

    let userNameLabel = UserInfoLabel(content: "", fontSize: .boldSystemFont(ofSize: 18), textColor: specialWhite)
    let follwerLabel = UserInfoLabel(content: "追蹤人數", fontSize: .boldSystemFont(ofSize: 18), textColor: specialWhite)
    let numberOfArticleLabel = UserInfoLabel(content: "文章數", fontSize: .boldSystemFont(ofSize: 18), textColor: specialWhite)
    let follwerNumberLabel = UserInfoLabel(content: "123", fontSize: .boldSystemFont(ofSize: 30), textColor: specialWhite)
    let aboutMeLabel = UserInfoLabel(content: "關於我", fontSize: .boldSystemFont(ofSize: 25), textColor: UIColor.black)
    lazy var articleNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = specialWhite
        label.font = .boldSystemFont(ofSize: 30)
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        let tap = UITapGestureRecognizer(target: self, action:  #selector(handleCheckArticles))
        label.addGestureRecognizer(tap)
        return label
    }()
    let abouMeTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "專門開箱模型\n歡迎相關廠商聯絡喔\n電話:0975007219\nFaceBook專頁:Andy開箱趣"
        textView.textAlignment = .center
        textView.textColor = UIColor(red: 172/255, green: 169/255, blue: 168/255, alpha: 1)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.backgroundColor = specialWhite
        textView.isEditable = false
        return textView
    }()
    lazy var stackView_Label: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(follwerLabel)
        stackView.addArrangedSubview(numberOfArticleLabel)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    lazy var followerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("追蹤", for: .normal)
        button.setTitleColor(specialCyan, for: .normal)
        button.backgroundColor = specialWhite
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowColor = shadowGray.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 2
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
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
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        isSubscribing { (bool) in
            if bool == true{
                self.followerButton.backgroundColor = specialCyan
                self.followerButton.setTitleColor(specialWhite, for: .normal)
                self.followerButton.setTitle("已追蹤", for: .normal)
            }else{
                self.followerButton.backgroundColor = specialWhite
                self.followerButton.setTitleColor(specialCyan, for: .normal)
                self.followerButton.setTitle("追蹤", for: .normal)
            }
        }
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
        self.view.addSubview(bottomView)
        self.view.addSubview(aboutMeLabel)
        self.view.addSubview(abouMeTextView)
        setUpNavBar()
        setUpTopView()
        setUpBottomView()
        fetchArticles()
        
    }
    func setUpNavBar(){
        self.navigationItem.title = "個人資料"
        let settingImg = UIImage(named: "settings2")
        let settingBarButton = UIBarButtonItem(image: settingImg, style: .plain, target: self, action: #selector(handleSetting))
        let isCurrentUser = article?.authorUID == Auth.auth().currentUser?.uid
        self.navigationItem.rightBarButtonItems = isCurrentUser ? [settingBarButton] : []
        followerButton.isHidden = isCurrentUser ? true : false
    }
    
    //MARK: - 追蹤處理
    private func addFollowers(uid: String){
        let userRef = ref.child("使用者").child(userUID!)
        //找尋當前使用者的追蹤名單
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            //第一次的時候會無法轉型
            if var follwersArray = dictionary["followers"] as? [String]{
                follwersArray.append(uid)
                self.updateFollowers(value: follwersArray)
            }else{
                guard let authorUID = self.article?.authorUID else{return}
                self.updateFollowers(value: [authorUID])
            }
            
        }
    }
    private func updateFollowers(value: [String]){
        let userRef = ref.child("使用者").child(userUID!)
        userRef.updateChildValues(["followers" : value]) { (error, ref) in
            if let error = error{
                print("error:",error)
                return
            }
        }
    }
    //MARK: - 點擊處理
    @objc func handleFollow(){
        //背景白色代表未追蹤
        let notFollwYet = followerButton.backgroundColor == specialWhite
        followerButton.backgroundColor = notFollwYet ? specialCyan : specialWhite
        
        if notFollwYet{
            followerButton.setTitleColor(specialWhite, for: .normal)
            followerButton.setTitle("已追蹤", for: .normal)
            guard let authorUID = self.authorUID else{return}
            addFollowers(uid: authorUID)
        }else{
            followerButton.setTitleColor(specialCyan, for: .normal)
            followerButton.setTitle("追蹤", for: .normal)
            let userRef = ref.child("使用者").child(userUID!)
            //找尋當前使用者的追蹤名單
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                let dictionary = snapshot.value as! [String : Any]
                //第一次的時候會無法轉型
                if let follwersArray = dictionary["followers"] as? [String]{
                    let newFollowersArray = follwersArray.filter({ (uid) -> Bool in
                        return uid != (self.article?.authorUID)!
                    })
                    self.updateFollowers(value: newFollowersArray)
                }else{
                    self.updateFollowers(value: [])
                }
                
            }
        }
    }
    @objc func handleCheckArticles(){
        let articlesController = ArticlesController(collectionViewLayout: UICollectionViewFlowLayout())
        articlesController.articlesArray = self.articlesArray
        self.navigationController?.pushViewController(articlesController, animated: true)
    }
    @objc func handleSetting(){
        print("set")
    }
    //MARK: - Fetch文章
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
    //確認是否有訂閱
    func isSubscribing(completion:@escaping (Bool)->Void){
        ref.child("使用者").child(userUID!).observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            if let followersArray = dictionary["followers"] as? [String]{
                for items in followersArray{
                    if items == self.article?.authorUID{
                        completion(true)
                        return
                    }
                }
                completion(false)
            }
            
        }
    }
    private func attemptReload(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
    }
    @objc func handleReload(){
        self.articlesArray.sort {$0.date! > $1.date!}
        self.articleNumberLabel.text = String(articlesArray.count)
    }
    func setUpTopView(){
        
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
        
        stackView_Label.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 15).isActive = true
        stackView_Label.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
        stackView_Label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView_Label.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 1).isActive = true
        
        stackView_Number.topAnchor.constraint(equalTo: stackView_Label.bottomAnchor, constant: 5).isActive = true
        stackView_Number.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
        stackView_Number.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView_Number.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 1).isActive = true

        
        followerButton.centerYAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true
        followerButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
        followerButton.heightAnchor.constraint(equalTo: backView.heightAnchor, multiplier: 0.1).isActive = true
        followerButton.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 0.45).isActive = true
    }
    func setUpBottomView(){
        bottomView.topAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: backView.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        

        aboutMeLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        aboutMeLabel.topAnchor.constraint(equalTo: followerButton.bottomAnchor, constant: 30).isActive = true
        
        abouMeTextView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 0).isActive = true
        abouMeTextView.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 9).isActive = true
        abouMeTextView.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -9).isActive = true
//        abouMeTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        abouMeTextView.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.7).isActive = true

    }
}


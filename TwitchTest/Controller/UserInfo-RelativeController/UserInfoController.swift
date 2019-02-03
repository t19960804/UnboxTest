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
    var user: User?{
        didSet{
            if let userImageURL = user?.imageURL,let userName = user?.userName,let authorUID = user?.uid{
                userImageView.downLoadImageInCache(downLoadURL: URL(string: userImageURL)!)
                userNameLabel.text = userName
                self.authorUID = authorUID
            }
        }
    }

    let cellID = "Cell"
    var articlesArray = [Article]()
    var timer: Timer?
    let ref = Database.database().reference()
    var authorUID = String()
    
    let userUID = Auth.auth().currentUser?.uid
    var followersArray = [User]()
    
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
    let aboutMeLabel = UserInfoLabel(content: "關於我", fontSize: .boldSystemFont(ofSize: 25), textColor: UIColor.black)
    lazy var editBarButton = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(handleEditing))

    lazy var follwerNumberLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = specialWhite
        label.textAlignment = .center
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCheckFollowers))
        label.addGestureRecognizer(tap)
        return label
    }()
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
        fetchArticles { (user) in
            self.abouMeTextView.text = user.aboutMe
            self.articlesArray.sort {$0.date! > $1.date!}
            self.articleNumberLabel.text = String(self.articlesArray.count)
        }
        fetchFollowers_2 {
            self.follwerNumberLabel.text = String(self.followersArray.count)
        }
//        fetchFollowers()
        addKeyBoardObserver()
    }
    func setUpNavBar(){
        self.navigationItem.title = "個人資料"
        let isCurrentUser = authorUID == Auth.auth().currentUser?.uid
        self.navigationItem.rightBarButtonItems = isCurrentUser ? [editBarButton] : []
        followerButton.isHidden = isCurrentUser ? true : false
    }
    //MARK: - 鍵盤處理
    func addKeyBoardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func handleKeyBoardShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.frame = CGRect(x: 0, y: -keyboardHeight, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: nil)
            
        }
    }
    @objc func handleKeyBoardHide(_ notification: Notification){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    //MARK: - 追蹤處理
    private func isSubscribing(completion:@escaping (Bool)->Void){
        ref.child("使用者").child(userUID!).observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            if let followersArray = dictionary["followers"] as? [String]{
                for items in followersArray{
                    if items == self.authorUID{
                        completion(true)
                        return
                    }
                }
                completion(false)
            }
            
        }
    }
    func addFollowers(uid: String){
        let userRef = ref.child("使用者").child(userUID!)
        //找尋當前使用者的追蹤名單
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            //第一次因為沒有followers節點會導致無法轉型,新增追蹤者時手用陣列包住
            if var follwersArray = dictionary["followers"] as? [String]{
                follwersArray.append(uid)
                self.updateFollowers(value: follwersArray)
            }else{
                self.updateFollowers(value: [self.authorUID])
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
    func deleteFollowers(followerUID: String){
        let userRef = ref.child("使用者").child(userUID!)
        //找尋當前使用者的追蹤名單
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            if let follwersArray = dictionary["followers"] as? [String]{
                let newFollowersArray = follwersArray.filter({ (uid) -> Bool in
                    return uid != followerUID
                })
                self.updateFollowers(value: newFollowersArray)
            }            
        }
    }
    //MARK: - Seletor方法
    @objc func handleCheckFollowers(){
        let followersController = FollowersController()
        followersController.followersArray = self.followersArray
        self.navigationController?.pushViewController(followersController, animated: true)
    }
    @objc func handleFollow(){
        //按下時判斷背景顏色是否為白色,白色代表未追蹤
        let notFollwYet = followerButton.backgroundColor == specialWhite
        let titleColor: UIColor = notFollwYet ? specialWhite : specialCyan
        let title: String = notFollwYet ? "已追蹤" : "追蹤"
        followerButton.backgroundColor = notFollwYet ? specialCyan : specialWhite
        followerButton.setTitleColor(titleColor, for: .normal)
        followerButton.setTitle(title, for: .normal)
        
        if notFollwYet{
            addFollowers(uid: authorUID)
        }else{
            guard let authorUID = user?.uid else{return}
            deleteFollowers(followerUID: authorUID)
        }
    }
    @objc func handleCheckArticles(){
        let articlesController = ArticlesController(collectionViewLayout: UICollectionViewFlowLayout())
        articlesController.articlesArray = self.articlesArray
        self.navigationController?.pushViewController(articlesController, animated: true)
    }
    @objc func handleEditing(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style: .plain, target: self, action: #selector(handleSaveUserInfo))
        abouMeTextView.isEditable = true
        abouMeTextView.becomeFirstResponder()
    }
    @objc func handleSaveUserInfo(){
        //First Responder 代表的是目前畫面中，處於焦點狀態的元件
        //而當輸入文字時，這個輸入框就是 First Responder
        //所以如果要隱藏鍵盤，當然就是將 First Responder 取消，也就是使用resignFirstResponder()方法。
        self.navigationItem.rightBarButtonItem = editBarButton
        abouMeTextView.isEditable = false
        abouMeTextView.resignFirstResponder()
        saveUserInfo(with: abouMeTextView.text)
    }
    func saveUserInfo(with userInfo: String){
        guard let userUID = userUID else{return}
        ref.child("使用者").child(userUID).updateChildValues(["aboutMe" : userInfo]) { (error, ref) in
            if let error = error{
                print("error:",error)
                return
            }
        }
    }
    @objc func handleReload(){
        self.articlesArray.sort {$0.date! > $1.date!}
        self.articleNumberLabel.text = String(articlesArray.count)
        self.follwerNumberLabel.text = String(followersArray.count)
    }
    //MARK: - Fetch資料
    //不能放ViewWillAppear,陣列會重複.append
    func fetchArticles(completion: @escaping (User) -> Void){
        //防止疊加
        if self.articlesArray.isEmpty == false{
            self.articlesArray.removeAll()
//            self.attemptReload()
        }
        ref.child("使用者-文章").child(authorUID).observe(.childAdded) { (snapshot) in
            let articleUID = snapshot.key
            //用Key找文章
            self.ref.child("文章").child(articleUID).observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as! [String : Any]
                guard let authorUID = dictionary["authorUID"] as? String else{return}
                var article = Article(value: dictionary)
                self.ref.child("使用者").child(authorUID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary = snapshot.value as! [String : Any]
                    let user = User(value: dictionary)
                    article.author = user
                    self.articlesArray.append(article)
                    completion(user)
                })
            })
        }
    }
    func fetchFollowers(){
        ref.child("使用者").child(authorUID).observe(.value, with: { (snapshot) in
            //防止疊加
            if self.followersArray.isEmpty == false{
                self.followersArray.removeAll()
                self.attemptReload()
            }
            let dictionary = snapshot.value as! [String : Any]
            //如果能轉型就至少有一位追蹤者
            if let followers = dictionary["followers"] as? [String]{
                for followerUID in followers{
                    self.ref.child("使用者").child(followerUID).observeSingleEvent(of: .value, with: { (snapshot) in
                        let dictionary = snapshot.value as! [String : Any]
                        let user = User(value: dictionary)
                        self.followersArray.append(user)
                        self.attemptReload()
                    })
                }
            }
        })
    }
    func fetchFollowers_2(completion: @escaping () -> Void){
        ref.child("使用者").child(authorUID).observe(.value, with: { (snapshot) in
            //防止疊加
            if self.followersArray.isEmpty == false{
                self.followersArray.removeAll()
                completion()
            }
            let dictionary = snapshot.value as! [String : Any]
            //如果能轉型就至少有一位追蹤者
            if let followers = dictionary["followers"] as? [String]{
                for followerUID in followers{
                    self.ref.child("使用者").child(followerUID).observeSingleEvent(of: .value, with: { (snapshot) in
                        let dictionary = snapshot.value as! [String : Any]
                        let user = User(value: dictionary)
                        self.followersArray.append(user)
                        completion()
                        return
                    })
                }
            }
        })
    }
    private func attemptReload(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
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
        abouMeTextView.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.7).isActive = true

    }
}


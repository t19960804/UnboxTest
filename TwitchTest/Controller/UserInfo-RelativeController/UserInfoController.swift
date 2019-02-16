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
import FirebaseStorage

import JGProgressHUD

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
        imageView.layer.borderColor = UIColor.specialWhite.cgColor
        imageView.layer.borderWidth = 4
        return imageView
    }()

    let userNameLabel = UserInfoLabel(content: "", fontSize: .boldSystemFont(ofSize: 18), textColor: .specialWhite)
    let follwerLabel = UserInfoLabel(content: "追蹤人數", fontSize: .boldSystemFont(ofSize: 18), textColor: .specialWhite)
    let numberOfArticleLabel = UserInfoLabel(content: "文章數", fontSize: .boldSystemFont(ofSize: 18), textColor: .specialWhite)
    let aboutMeLabel = UserInfoLabel(content: "關於我", fontSize: .boldSystemFont(ofSize: 25), textColor: UIColor.black)
    lazy var editBarButton = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(handleEditing))

    lazy var chooseImageButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "camera24")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .specialWhite
        button.backgroundColor = .specialCyan
        button.layer.cornerRadius = 20
        button.isHidden = true
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleChooseImage), for: .touchUpInside)
        return button
    }()
    lazy var follwerNumberLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .specialWhite
        label.textAlignment = .center
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCheckFollowers))
        label.addGestureRecognizer(tap)
        return label
    }()
    lazy var articleNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .specialWhite
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
        textView.backgroundColor = .specialWhite
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
        button.setTitleColor(.specialCyan, for: .normal)
        button.backgroundColor = .specialWhite
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowColor = UIColor.shadowGray.cgColor
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {self.view.endEditing(true)}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .specialWhite
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
        self.view.addSubview(chooseImageButton)

        setUpNavBar()
        setUpTopView()
        setUpBottomView()
        addKeyBoardObserver()
        fetchArticles { (user) in
            self.abouMeTextView.text = user.aboutMe
            self.articlesArray.sort {$0.date! > $1.date!}
            self.articleNumberLabel.text = String(self.articlesArray.count)
        }
        fetchFollowers {
            self.follwerNumberLabel.text = String(self.followersArray.count)
        }
        observeArticlesRemove {
            self.articleNumberLabel.text = String(self.articlesArray.count)
        }
        isSubscribing { (result) in
            let titleColor: UIColor = result ? .specialWhite : .specialCyan
            let title = result ? "已追蹤" : "追蹤"
            self.followerButton.backgroundColor = result ? .specialCyan : .specialWhite
            self.followerButton.setTitle(title, for: .normal)
            self.followerButton.setTitleColor(titleColor, for: .normal)
        }
     
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
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
    @objc func handleChooseImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    @objc func handleKeyBoardShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.frame = CGRect(x: 0, y: -(keyboardHeight / 2), width: self.view.frame.width, height: self.view.frame.height)
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
        ref.child("使用者").child(userUID!).observe(.value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            if let followingArray = dictionary["following"] as? [String]{
                for items in followingArray{
                    if items == self.authorUID{
                        completion(true)
                        return
                    }
                }
                completion(false)
            }
        }
        
    }
    func addFollowData(add uid1: String,to uid2: String,path: String){
        let toRef = ref.child("使用者").child(uid2)
        //找尋當前使用者的追蹤名單
        toRef.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            //第一次因為沒有followers節點會導致無法轉型,新增追蹤者時手用陣列包住
            if var array = dictionary[path] as? [String]{
                array.append(uid1)
                self.updateFollowData(value: array,to: uid2,path: path)
            }else{
                self.updateFollowData(value: [uid1],to: uid2,path: path)
            }
            
        }
    }
    
    private func updateFollowData(value: [String],to uid: String,path: String){
        let toRef = ref.child("使用者").child(uid)
        toRef.updateChildValues([path : value]) { (error, ref) in
            if let error = error{
                print("error:",error)
                return
                
            }
        }
    }
    func deleteFollowData(delete uid1: String,from uid2: String,path: String){
        let fromRef = ref.child("使用者").child(uid2)
        //找尋當前使用者的追蹤名單
        fromRef.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            if let follwersArray = dictionary[path] as? [String]{
                let newFollowersArray = follwersArray.filter({ (uid) -> Bool in
                    return uid != uid1
                })
                self.updateFollowData(value: newFollowersArray,to: uid2,path: path)
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
        let notFollwYet = followerButton.backgroundColor == .specialWhite
        let titleColor: UIColor = notFollwYet ? .specialWhite : .specialCyan
        let title: String = notFollwYet ? "已追蹤" : "追蹤"
        followerButton.backgroundColor = notFollwYet ? .specialCyan : .specialWhite
        followerButton.setTitleColor(titleColor, for: .normal)
        followerButton.setTitle(title, for: .normal)
        guard let authorUID = user?.uid else{return}

        if notFollwYet{
            addFollowData(add: userUID!, to: authorUID,path: "followers")
            addFollowData(add: authorUID, to: userUID!,path: "following")
        }else{
            deleteFollowData(delete: userUID!,from: authorUID,path: "followers")
            deleteFollowData(delete: authorUID,from: userUID!,path: "following")
        }
    }
    @objc func handleCheckArticles(){
        let articlesController = ArticlesController(collectionViewLayout: UICollectionViewFlowLayout())
        articlesController.articlesArray = self.articlesArray
        self.navigationController?.pushViewController(articlesController, animated: true)
    }
    @objc func handleEditing(){
        chooseImageButton.isHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style: .plain, target: self, action: #selector(handleSaveUserInfo))
        abouMeTextView.isEditable = true
        abouMeTextView.becomeFirstResponder()
    }
    @objc func handleSaveUserInfo(){
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "編輯成功"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: self.view, animated: true)
        //First Responder 代表的是目前畫面中，處於焦點狀態的元件
        //而當輸入文字時，這個輸入框就是 First Responder
        //所以如果要隱藏鍵盤，當然就是將 First Responder 取消，也就是使用resignFirstResponder()方法。
        self.navigationItem.rightBarButtonItem = editBarButton
        abouMeTextView.isEditable = false
        abouMeTextView.resignFirstResponder()
        chooseImageButton.isHidden = true
        saveUserInfo(with: abouMeTextView.text)
        hud.dismiss(afterDelay: 0.6, animated: true)
    }
    func saveUserInfo(with userInfo: String){
        
        let imageUID = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("userImages").child(imageUID)
        guard let userImage = self.userImageView.image?.jpegData(compressionQuality: 0.2) else{return}
        storageRef.putData(userImage, metadata: nil) { (metaData, error) in
            if let error = error{
                print("error:",error)
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if let error = error{
                    print("error:",error)
                    return
                }
                let values: [String : Any] = ["aboutMe" : userInfo,
                                              "imageURL" : url!.absoluteString]
                self.updateToDataBase(values: values)
            })
        }

        
    }
    func updateToDataBase(values: [String : Any]){
        guard let userUID = userUID else{return}
        self.ref.child("使用者").child(userUID).updateChildValues(values) { (error, ref) in
            if let error = error{
                print("error:",error)
                return
            }
            
        }
    }
    
    //MARK: - Fetch資料
    //不能放ViewWillAppear,陣列會重複.append
    func fetchArticles(completion: @escaping (User) -> Void){
        //由於結構上的失誤
        //當使用者沒有文章時無法觀察"使用者-文章",導致articlesArray為0
        
        //防止疊加
        if self.articlesArray.isEmpty == false{
            self.articlesArray.removeAll()
        }else{
            ref.child("使用者").child(authorUID).observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as! [String : Any]
                let user = User(value: dictionary)
                completion(user)
                return
            })
        }

        ref.child("使用者-文章").child(authorUID).observe(.childAdded) { (snapshot) in
            let articleUID = snapshot.key
            //用Key找文章
            self.ref.child("文章").child(articleUID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : Any]{
                    guard let authorUID = dictionary["authorUID"] as? String else{return}
                    var article = Article(value: dictionary)
                    self.ref.child("使用者").child(authorUID).observeSingleEvent(of: .value, with: { (snapshot) in
                        let dictionary = snapshot.value as! [String : Any]
                        let user = User(value: dictionary)
                        article.author = user
                        self.articlesArray.append(article)
                        completion(user)
                    })
                }

            })
        }
    
    }
    //觀察文章被移除
    func observeArticlesRemove(completion: @escaping () -> Void){
        let ref = Database.database().reference()
        ref.child("使用者-文章").child(userUID!).observe(.childRemoved) { (snapshot) in
            self.articlesArray = self.articlesArray.filter({ (article) -> Bool in
                return article.articleUID != snapshot.key
            })
            completion()
        }
    }
    func fetchFollowers(completion: @escaping () -> Void){
        ref.child("使用者").child(authorUID).observe(.value, with: { (snapshot) in
            //防止疊加
            if self.followersArray.isEmpty == false{
                self.followersArray.removeAll()
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
                    })
                }
            }else{
                completion()
                return
            }
        })
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
        
        
        chooseImageButton.centerYAnchor.constraint(equalTo: userImageView.topAnchor).isActive = true
        chooseImageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        chooseImageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        chooseImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
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

extension UserInfoController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        userImageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

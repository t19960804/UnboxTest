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
//        imageView.layer.borderColor = specialYellow.cgColor
//        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 75
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = specialWhite
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "AsiaGodTone"
        return label
    }()
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
    lazy var stackView_Number: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(follwerNumberLabel)
        stackView.addArrangedSubview(articleNumberLabel)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    lazy var articlesCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        layout.itemSize = CGSize(width: self.view.frame.width - 36, height: ((self.view.frame.height * 0.5) - (36 + 18)) / 2)
        layout.minimumLineSpacing = 18
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UserInfoCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = specialWhite
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNumbersOfArticle()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "個人資料"
        self.view.addSubview(backImageView)
        self.view.addSubview(backView)
        self.view.addSubview(userImageView)
        self.view.addSubview(userNameLabel)
        self.view.addSubview(stackView_Label)
        self.view.addSubview(stackView_Number)
        self.view.addSubview(articlesCollectionView)
        
        
        
        
        articlesCollectionView.delegate = self
        articlesCollectionView.dataSource = self
        setUpConstraints()
        setUpCollectionView()
        fetchArticles()
        
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
                    self.attemptReloadTableView()
                })
            })
        }
    }
    private func attemptReloadTableView(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    @objc func handleReloadTable(){
        self.articlesArray.sort {$0.date! > $1.date!}
        DispatchQueue.main.async {
            self.articlesCollectionView.reloadData()
        }
        
    }
    //取得使用者的文章
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
    }
    func setUpCollectionView(){
        articlesCollectionView.topAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true
        articlesCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        articlesCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        articlesCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

}
extension UserInfoController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserInfoCell
        cell.article = articlesArray[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articleDetailController = ArticleDeatailController()
        articleDetailController.article = articlesArray[indexPath.row]
        self.navigationController?.pushViewController(articleDetailController, animated: true)
    }
    
    
}

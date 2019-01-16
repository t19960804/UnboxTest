//
//  CategoryCollectionViewController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/12/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON
import JGProgressHUD

private let reuseIdentifier = "Cell"

class ArticlesCollectionViewController: UICollectionViewController {
    var articlesArray = [Article]()
    var usersArray = [User]()
    var timer: Timer?
    let hud = JGProgressHUD(style: .light)
    var category: String?{
        didSet{
            self.navigationItem.title = category!
            fetchArticlesFromdDataBase()
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        hud.textLabel.text = "載入中"
        hud.show(in: self.view, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        hud.dismiss(afterDelay: 1, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView!.register(ArticlesCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = themeGrayColor
        self.navigationController?.navigationBar.tintColor = UIColor.white

        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: self.view.frame.width - 20, height: 250)
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        setUpNavBar()
        
    }
    func fetchArticlesFromdDataBase(){
        guard let category = self.navigationItem.title else{return}
        let ref = Database.database().reference()
        
        ref.child("類別").child(category).observe(.childAdded, with: { (snapshot) in
            //取得文章的UID,透過UID尋找文章
            let articleUID = snapshot.key
            ref.child("文章").child(articleUID).observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as! [String : Any]
                let article = Article(value: dictionary)
                self.articlesArray.append(article)
                //透過文章中的author找尋作者資料
                ref.child("users").child(dictionary["author"] as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary = snapshot.value as! [String : Any]
                    let user = User(value: dictionary)
                    ////////////////
                    article.author2 = user
                    ////////////////
                    self.usersArray.append(user)
                    //不延遲會無法載入圖片
                    self.attemptReloadTableView()
                }, withCancel: nil)
                
                
            })
            
        }, withCancel: nil)
    }
    private func attemptReloadTableView(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    @objc func handleReloadTable(){
        self.articlesArray.sort {$0.date! > $1.date!}
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            let firstIndexPath = IndexPath(item: 0, section: 0)
            self.collectionView.scrollToItem(at: firstIndexPath, at: .top, animated: true)
        }
        
    }
    func setUpNavBar(){
        let pencilImage = UIImage(named: "edit")
        let userImage = UIImage(named: "user2")
        let postArticleButton = UIBarButtonItem(image:pencilImage, style: .plain, target: self, action: #selector(handlePostArticle))
        let checkSelfButton = UIBarButtonItem(image:userImage, style: .plain, target: self, action: #selector(handleCheckSelf))
        self.navigationItem.rightBarButtonItems = [checkSelfButton,postArticleButton]
    }
    @objc func handlePostArticle(){
        let postArticleController = PostArticleController()
        postArticleController.kindOfCategory = self.navigationItem.title
        self.navigationController?.pushViewController(postArticleController, animated: true)
    }
    @objc func handleCheckSelf(){
        print("self")
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArticlesCell
        cell.article = articlesArray[indexPath.row]
        cell.user = articlesArray[indexPath.row].author2
        //cell.user = usersArray[indexPath.row]
        return cell
    }
    
    
   

}

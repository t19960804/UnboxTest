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

private let reuseIdentifier = "Cell"

class ArticlesCollectionViewController: UICollectionViewController {
    var articlesArray = [Article]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView!.register(ArticlesCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = specialWhite
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: self.view.frame.width - 20, height: 250)
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        setUpNavBar()
        fetchArticlesFromdDataBase()
    }
    func fetchArticlesFromdDataBase(){
        guard let category = self.navigationItem.title else{return}
        let ref = Database.database().reference()
        
        
        ref.child("類別").child(category).observe(.childAdded, with: { (snapshot) in
            //取得文章的UID,透過UID尋找文章
            let articleUID = snapshot.key
            ref.child("文章").child(articleUID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! [String : Any]
                let article = Article(value: value)
                self.articlesArray.append(article)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
        }, withCancel: nil)
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
        cell.backgroundColor = specialYellow
    
        return cell
    }

   

}

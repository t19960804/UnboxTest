//
//  ArticlesController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/28/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD


class ArticlesController: UICollectionViewController {
    let cellID = "Cell"
    var articlesArray = [Article]()
    let ref = Database.database().reference()
    let hud = JGProgressHUD(style: .light)
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "尚無文章!"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .specialGray2
        return label
    }()
    override func viewWillAppear(_ animated: Bool) {
        hud.textLabel.text = "載入中"
        hud.show(in: self.view, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        hud.dismiss(afterDelay: 0.6, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .specialWhite
        self.navigationItem.title = "過往文章"
        self.collectionView!.register(UserInfoCell.self, forCellWithReuseIdentifier: cellID)
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: self.view.frame.width - 20, height: self.view.frame.height * 0.2)
            layout.scrollDirection = .vertical
        }
        self.view.addSubview(messageLabel)
        setUpConstraints()
        observeArticlesRemove {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        messageLabel.isHidden = articlesArray.isEmpty ? false : true
    }
    func setUpConstraints(){
        messageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    func observeArticlesRemove(completion: @escaping () -> Void){
        let ref = Database.database().reference()
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        ref.child("使用者-文章").child(currentUser).observe(.childRemoved) { (snapshot) in
            self.articlesArray = self.articlesArray.filter({ (article) -> Bool in
                return article.articleUID != snapshot.key
            })
            completion()
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserInfoCell
        cell.delegate = self
        cell.article = articlesArray[indexPath.row]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articleDetailController = ArticleDeatailController()
        articleDetailController.article = articlesArray[indexPath.row]
        self.navigationController?.pushViewController(articleDetailController, animated: true)
    }

}
extension ArticlesController: UserInfoCell_Delegate{
    
    func showDeleteAlert(article: Article) {
        let alert = UIAlertController(title: "警告", message: "確定刪除文章?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { (action) in
            guard let currentUser = Auth.auth().currentUser?.uid else{return}
            guard let articleUID = article.articleUID,let category = article.category else{return}
            //從"使用者-文章"刪除
            self.ref.child("使用者-文章").child(currentUser).child(articleUID).removeValue(completionBlock: { (error, ref) in
                self.hud.textLabel.text = "刪除中"
                self.hud.show(in: self.view, animated: true)
                if let error = error{
                    print("error:",error)
                    return
                }
            })
            //從"文章"刪除
            self.ref.child("文章").child(articleUID).removeValue(completionBlock: { (error, ref) in
                if let error = error{
                    print("error:",error)
                    return
                }
            })
            //從"類別"刪除
            self.ref.child("類別").child(category).child(articleUID).removeValue(completionBlock: { (error, ref) in
                if let error = error{
                    print("error:",error)
                    return
                }
                self.hud.dismiss(afterDelay: 0.6, animated: true)
            })
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

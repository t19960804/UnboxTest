//
//  AllGamesCollectionViewController.swift
//  TwitchTest
//
//  Created by t19960804 on 2019/1/9.
//  Copyright © 2019 t19960804. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseDatabase

private let reuseIdentifier = "Cell"

class AllCommodityCollectionViewController: UICollectionViewController{
    
    let category = ["3C產品","美妝","家電","動漫模型","運動用品","零食","精品","嬰幼兒用品"]
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpCollectionView()
        observeCurrentUser { (user) in
            self.currentUser = user
        }
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: (self.view.frame.width - 30) / 2, height: 250)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        if UserDefaults.standard.isLogIn(){
            return
        }else{
            self.present(LoginController(), animated: true, completion: nil)
        }
        
        
    }
    func observeCurrentUser(completion: @escaping (User) -> Void){
        guard let currentUser = Auth.auth().currentUser?.uid else{return}
        let ref = Database.database().reference()
        ref.child("使用者").child(currentUser).observe(.value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            let user = User(value: dictionary)
            completion(user)
        }
    }
    func setUpCollectionView(){
        self.collectionView!.register(CategoryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = specialWhite
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    func setUpNavBar(){
        self.navigationItem.title = "商品分類"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        //NavBar的Title顏色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        
        let logoutButton = UIBarButtonItem(title: "登出", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleLogout))
        let checkProfileButton = UIBarButtonItem(image: UIImage(named: "avatar"), style: .plain, target: self, action: #selector(handleCheckProfile))
        self.navigationItem.leftBarButtonItem = logoutButton
        self.navigationItem.rightBarButtonItem = checkProfileButton
    }
    
    @objc func handleCheckProfile(){
        let userInfoController = UserInfoController()
        userInfoController.user = currentUser
        self.navigationController?.pushViewController(userInfoController, animated: true)
    }
    @objc func handleLogout(){
        try? Auth.auth().signOut()
        UserDefaults.standard.setIsLogIn(value: false)
        self.present(LoginController(), animated: true, completion: nil)
    }
  
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        cell.category = category[indexPath.row]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articlesCollectionViewController = ArticlesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        articlesCollectionViewController.category = category[indexPath.row]
        self.navigationController?.pushViewController(articlesCollectionViewController, animated: true)
    }
}

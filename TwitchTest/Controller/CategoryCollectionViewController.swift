//
//  CategoryCollectionViewController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/12/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "Cell"

class ArticlesCollectionViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView!.register(ArticlesCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = specialGray
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: self.view.frame.width - 20, height: 250)
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        setUpNavBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        print(Auth.auth().currentUser?.uid)
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
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArticlesCell
        cell.backgroundColor = specialYellow
    
        return cell
    }

   

}

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



class ArticlesController: UICollectionViewController {
    let cellID = "Cell"
    var articlesArray = [Article]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = specialWhite
        self.navigationItem.title = "過往文章"
        self.collectionView!.register(UserInfoCell.self, forCellWithReuseIdentifier: cellID)
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: self.view.frame.width - 20, height: self.view.frame.height * 0.2)
            layout.scrollDirection = .vertical
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
        cell.article = articlesArray[indexPath.row]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articleDetailController = ArticleDeatailController()
        articleDetailController.article = articlesArray[indexPath.row]
        self.navigationController?.pushViewController(articleDetailController, animated: true)
    }

}

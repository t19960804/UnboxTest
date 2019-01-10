//
//  AllGamesCollectionViewController.swift
//  TwitchTest
//
//  Created by t19960804 on 2019/1/9.
//  Copyright © 2019 t19960804. All rights reserved.
//


import UIKit
import SwiftyJSON
private let reuseIdentifier = "Cell"

class AllCommodityCollectionViewController: UICollectionViewController{
    
    let category = ["3c產品","美妝","家電","動漫模型","運動用品","零食","精品","嬰幼兒用品"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpNavBar()
        self.collectionView!.register(CategoryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.white
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: (self.view.frame.width - 20) / 2, height: 250)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
        
        
    }
    func setUpNavBar(){
        self.navigationItem.title = "商品分類"
        //NavBar顏色
        self.navigationController?.navigationBar.barTintColor = themeGrayColor
        //NavBar的Title顏色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let button = UIBarButtonItem(title: "登出", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleLogout))
        button.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = button
    }
    @objc func handleLogout(){
        self.present(LoginController(), animated: true, completion: nil)
    }
  
    //操你媽
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        cell.categoryImageView.image = UIImage(named: category[indexPath.row])
        cell.categoryLabel.text = category[indexPath.row]
        return cell
    }

}

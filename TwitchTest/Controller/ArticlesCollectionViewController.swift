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
    var filterdArticles = [Article]()
    
    var timer: Timer?
    let hud = JGProgressHUD(style: .light)
    var category: String?{
        didSet{
            self.navigationItem.title = category!
            fetchArticlesFromdDataBase()
        }
    }
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        return searchBar
    }()
    let messageLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "尚無文章!"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = specialGray2
        return label
    }()
    let pencilImage = UIImage(named: "edit")
    let searchImage = UIImage(named: "search")
    lazy var postArticleButton = UIBarButtonItem(image:pencilImage, style: .plain, target: self, action: #selector(handlePostArticle))
    lazy var searchButton = UIBarButtonItem(image:searchImage, style: .plain, target: self, action: #selector(handleSearch))
    override func viewWillAppear(_ animated: Bool) {
        hud.textLabel.text = "載入中"
        hud.show(in: self.view, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        hud.dismiss(afterDelay: 1, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        self.collectionView!.register(ArticlesCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = specialWhite
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: self.view.frame.width - 20, height: 450)
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        self.view.addSubview(messageLabel)
        self.navigationItem.rightBarButtonItems = [postArticleButton,searchButton]
        setUpMessageLabel()
    }
    func setUpMessageLabel(){
        messageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    //MARK: - Fetch資料
    func fetchArticlesFromdDataBase(){
        guard let category = self.navigationItem.title else{return}
        let ref = Database.database().reference()
        
        ref.child("類別").child(category).observe(.childAdded, with: { (snapshot) in
            //取得文章的UID,透過UID尋找文章
            let articleUID = snapshot.key
            ref.child("文章").child(articleUID).observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as! [String : Any]
                let article = Article(value: dictionary)
                let author = dictionary["authorUID"] as! String
                //透過文章中的author找尋作者資料
                ref.child("使用者").child(author).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary = snapshot.value as! [String : Any]
                    let user = User(value: dictionary)
                    article.author = user
                    self.articlesArray.append(article)
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
        self.filterdArticles = self.articlesArray
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            let firstIndexPath = IndexPath(item: 0, section: 0)
            self.collectionView.scrollToItem(at: firstIndexPath, at: .top, animated: true)
        }
        
    }
    @objc func handlePostArticle(){
        let postArticleController = PostArticleController()
        postArticleController.kindOfCategory = self.navigationItem.title
        self.navigationController?.pushViewController(postArticleController, animated: true)
    }
    @objc func handleSearch(){
        self.navigationItem.rightBarButtonItems = []
        self.navigationItem.titleView = searchBar
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterdArticles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        messageLabel.isHidden = true
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArticlesCell
        cell.article = filterdArticles[indexPath.row]
        cell.delegate = self
        return cell
    }
    
   

}
extension ArticlesCollectionViewController: ArticleCellDelegate,UISearchBarDelegate{
    func pushToArticleDetail(article: Article) {
        let articleDetailController = ArticleDeatailController()
        articleDetailController.article = article
        self.navigationController?.pushViewController(articleDetailController, animated: true)
    }
    //監聽輸入
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let input = searchBar.text else{return}
        if searchText.isEmpty{
            filterdArticles = articlesArray
        }else{
            filterdArticles = articlesArray.filter({ (article) -> Bool in
                return article.title!.contains(input)
            })
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }

    }
    //開始輸入時顯示Cancel按鈕
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    //按下Cancel後
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItems = [postArticleButton,searchButton]
        self.navigationItem.titleView = nil
    }
    
    
    
}

//
//  ArticleDeatailController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/17/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ArticleDeatailController: UIViewController {
    let cellID = "Cell"
    var reviewTextViewHeightAnchor: NSLayoutConstraint?
    var startingFrame: CGRect?
    var background: UIView?
    var startingImageView: UIImageView?
    var article: Article?{
        didSet{
            if let imagesURl = article?.imageURL,let title = article?.title,let userImageURL = article?.author?.imageURL,
                let userName = article?.author?.userName,let review = article?.review{
                imageURLArray = imagesURl
                userImageView.downLoadImageInCache(downLoadURL: URL(string: userImageURL)!)
                titleLabel.text = title
                userNameLabel.text = userName
                reviewTextView.text = review
            }
        }
    }
    var imageURLArray = [String]()
    var loveImageViewArray = [UIImageView]()

    lazy var detailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.45)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ArticleDetailCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
        
    }()
    lazy var halfViewHeight = self.view.frame.height / 2
    lazy var myScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame:self.view.frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width:self.view.frame.width , height: halfViewHeight + estimateTextViewFrame(string: reviewTextView.text, fontSize: UIFont.systemFont(ofSize: 20)).height + 80)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    let backGroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleToUserInfo))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .specialWhite
        return label
    }()
    

    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .specialWhite
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        return textView
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        //評論區動態拉高
        reviewTextViewHeightAnchor?.constant = estimateTextViewFrame(string: reviewTextView.text, fontSize: UIFont.systemFont(ofSize: 20)).height + 80
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .specialWhite
        self.navigationItem.title = "商品詳情"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "comment"), style: .plain, target: self, action: #selector(handleComment))
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self

        setUpConstraints()
        
        if article?.authorUID == Auth.auth().currentUser?.uid{
            observeUserImageChanged { (url) in
                self.userImageView.downLoadImageInCache(downLoadURL: URL(string: url)!)
            }
        }
        
       
    }
    @objc func handleComment(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let commentController = CommentController(collectionViewLayout: layout)
        commentController.articleDetailController = self
        commentController.article = self.article
        self.navigationController?.pushViewController(commentController, animated: true)
        
    }
    @objc func handleToUserInfo(){
        let userInfoController = UserInfoController()
        userInfoController.user = article?.author
        self.navigationController?.pushViewController(userInfoController, animated: true)
    }
    
    //計算動態TextView高度
    func estimateTextViewFrame(string: String,fontSize: UIFont) -> CGRect{
        //size,限制的size,不然不知道哪裡換行
        //usesLineFragmentOrigin,文本将以每行组成的矩形为单位计算整个文本的尺寸
        //attributes,字體大小
        let constraintSize = CGSize(width: self.view.frame.width * 0.8, height: 1000)
        let estimateFrame = NSString(string: string).boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : fontSize], context: nil)
        return estimateFrame
    }
   
    func setUpConstraints(){
        self.view.addSubview(myScrollView)
        
        myScrollView.addSubview(backGroundView)
        backGroundView.addSubview(titleLabel)
        
        backGroundView.addSubview(reviewTextView)
        backGroundView.addSubview(detailCollectionView)
        backGroundView.addSubview(userImageView)
        backGroundView.addSubview(userNameLabel)
        
        myScrollView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: safeAreaHeight_Top + 44).isActive = true
        myScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        myScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        myScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        //backGroundView的高要和scrollview的contentSize相等
        backGroundView.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive = true
        backGroundView.heightAnchor.constraint(equalToConstant: halfViewHeight + estimateTextViewFrame(string: reviewTextView.text, fontSize: UIFont.systemFont(ofSize: 20)).height + 80 ).isActive = true
        backGroundView.topAnchor.constraint(equalTo: myScrollView.topAnchor).isActive = true
        backGroundView.centerXAnchor.constraint(equalTo: myScrollView.centerXAnchor).isActive = true
        
        detailCollectionView.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor).isActive = true
        detailCollectionView.topAnchor.constraint(equalTo: backGroundView.topAnchor).isActive = true
        detailCollectionView.widthAnchor.constraint(equalTo: backGroundView.widthAnchor, multiplier: 1).isActive = true
        detailCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.45).isActive = true
        
        userImageView.topAnchor.constraint(equalTo: detailCollectionView.topAnchor, constant: 8).isActive = true
        userImageView.leftAnchor.constraint(equalTo: reviewTextView.leftAnchor,constant: 8).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true
        
        
        titleLabel.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: detailCollectionView.bottomAnchor, constant: 20).isActive = true
        
        
        
        reviewTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        reviewTextView.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor).isActive = true
        reviewTextView.widthAnchor.constraint(equalTo: backGroundView.widthAnchor, multiplier: 0.8).isActive = true
        reviewTextViewHeightAnchor = reviewTextView.heightAnchor.constraint(equalToConstant: 200)
        reviewTextViewHeightAnchor?.isActive = true
        
        
    }
    //觀察使用者更換頭像
    func observeUserImageChanged(completion: @escaping (String) -> Void){
        let ref = Database.database().reference()
        guard let userUID = Auth.auth().currentUser?.uid else{return}
        ref.child("使用者").child(userUID).child("imageURL").observe(.value) { (snapshot) in
            if let url = snapshot.value as? String{
                completion(url)
            }
        }
    }

}
extension ArticleDeatailController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.detailCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ArticleDetailCell
        cell.delegate = self
        cell.imageURL = imageURLArray[indexPath.row]
        return cell
    }
    
    
}
extension ArticleDeatailController: ArticleDetailCell_Delagate{
    func imageZoomInForStartingImageView(startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        //找出imageView在當前畫面的frame
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = .black
        zoomingImageView.image = startingImageView.image
        //加入縮回去的動作
        zoomingImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleZoomOut))
        zoomingImageView.addGestureRecognizer(tap)
        //加入畫面中
        //keyWindow.frame 相等 self.view.frame
        if let keyWindow = UIApplication.shared.keyWindow{
            background = UIView(frame: keyWindow.frame)
            background?.backgroundColor = .black
            background?.alpha = 0
            keyWindow.addSubview(background!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.userImageView.alpha = 0
                self.userNameLabel.alpha = 0
                self.background?.alpha = 1
                //等比例放大
                // h2 / w2 = h1 / w1
                //h2 = (h1 / w1)*w2
                let endingHeight = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: endingHeight)
                zoomingImageView.center = keyWindow.center
            })
        }
       
        

    }
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer){
        if let imageView = tapGesture.view as? UIImageView{
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                guard let startingFrame = self.startingFrame else{return}
                self.background?.alpha = 0
                
                imageView.frame = startingFrame
            }) { (complete) in
                    imageView.removeFromSuperview()
                    self.startingImageView?.isHidden = false
                    self.userImageView.alpha = 1
                    self.userNameLabel.alpha = 1
            }

            
        }
    }
    
    
    
}

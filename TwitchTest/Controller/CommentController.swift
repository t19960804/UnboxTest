//
//  CommentController.swift
//  TwitchTest
//
//  Created by t19960804 on 3/1/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

import JGProgressHUD


class CommentController: UICollectionViewController {
    let cellID = "Cell"
    let ref = Database.database().reference()
    var commentViewBottomAnchor: NSLayoutConstraint?
    var article: Article?
    let hud = JGProgressHUD(style: .dark)
    var comments = [Comment]()
    var timer: Timer?
    
    let commentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    lazy var commentTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "輸入留言..."
        textField.delegate = self
        return textField
    }()
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .setRGB(red: 171, green: 237, blue: 216)
        button.setImage(UIImage(named: "right-arrow24")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleSendComment), for: .touchUpInside)
        button.imageView?.tintColor = .setRGB(red: 61, green: 132, blue: 168)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .specialWhite
        self.navigationItem.title = "留言板"
        self.collectionView!.register(CommentCell.self, forCellWithReuseIdentifier: cellID)
        setUpConstraints()
        addKeyboardObserver()
        fetchComments()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        hud.dismiss(afterDelay: 1, animated: true)
    }
    func fetchComments(){
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.textLabel.text = "載入中"
        hud.show(in: self.view, animated: true)
        
        guard let articleUID = self.article?.articleUID else{return}
        ref.child("文章").child(articleUID).child("comments").observe(.childAdded) { (snapshot) in
            if let commentUID = snapshot.value as? String{
                self.ref.child("評論").child(commentUID).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String : Any]{
                        var comment = Comment(value: dictionary)

                        //透過comment裡的authorUID包裝成User
                        if let authorUID = dictionary["author"] as? String{
                            self.ref.child("使用者").child(authorUID).observeSingleEvent(of: .value, with: { (snapshot) in
                                if let dictionary = snapshot.value as? [String : Any]{
                                    let author = User(value: dictionary)
                                    comment.author = author
                                    self.comments.append(comment)
                                    self.attemptReloadData()
                                }
                                
                            })
                            
                        }
                        
                    }
                })
            }
        }
    }
    private func attemptReloadData(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReloadData), userInfo: nil, repeats: false)
    }
    @objc func handleReloadData(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    @objc func handleSendComment(){
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.textLabel.text = "上傳中"
        hud.show(in: self.view, animated: true)
        
        let commentUID = NSUUID().uuidString
        guard let currntUserUID = Auth.auth().currentUser?.uid else{return}
        guard let articleUID = self.article?.articleUID else{return}
        let textInput = commentTextField.text
        
        if textInput?.isEmpty == false{
            let value = ["comment" : textInput!,
                         "author" : currntUserUID]
            //新增至"評論"以及該文章底下
            ref.child("評論").child(commentUID).setValue(value)
            ref.child("文章").child(articleUID).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String : Any]{
                    if var comments = dictionary["comments"] as? [String]{
                        comments.append(commentUID)
                        self.update(with: articleUID, value: comments)
                        
                    }else{
                        self.update(with: articleUID, value: [commentUID])
                    }
                }
                
            }
            
        }
    }
    func update(with articleUID: String,value: [String]){
        self.ref.child("文章").child(articleUID).updateChildValues(["comments" : value], withCompletionBlock: { (error, ref) in
            if let error = error{
                print("error:\(error)")
                return
            }
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.textLabel.text = "上傳成功"
            self.hud.dismiss(animated: true)
        })
    }
    func addKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func handleKeyboardShow(_ notification: Notification){
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            commentViewBottomAnchor?.constant = -keyboardHeight
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func handleKeyboardHide(_ notification: Notification){
       commentViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    func setUpConstraints(){
        self.view.addSubview(commentView)
        self.view.addSubview(commentTextField)
        self.view.addSubview(sendButton)
        
        commentView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        commentViewBottomAnchor = commentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        commentViewBottomAnchor?.isActive = true

        commentView.heightAnchor.constraint(equalToConstant: 58).isActive = true
        commentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        commentTextField.leftAnchor.constraint(equalTo: commentView.leftAnchor).isActive = true
        commentTextField.bottomAnchor.constraint(equalTo: commentView.bottomAnchor).isActive = true
        commentTextField.widthAnchor.constraint(equalTo: commentView.widthAnchor, multiplier: 0.8).isActive = true
        commentTextField.heightAnchor.constraint(equalTo: commentView.heightAnchor).isActive = true
        
        sendButton.leftAnchor.constraint(equalTo: commentTextField.rightAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: commentView.rightAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: commentView.bottomAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: commentTextField.heightAnchor).isActive = true
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.row]
        
        return cell
    }
   
  

}
extension CommentController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 180)
    }
}
extension CommentController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
}

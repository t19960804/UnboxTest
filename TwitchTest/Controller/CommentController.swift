//
//  CommentController.swift
//  TwitchTest
//
//  Created by t19960804 on 3/1/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CommentController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    let commentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .blue
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("送出", for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .specialWhite
        self.navigationItem.title = "留言板"
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    func setUpConstraints(){
        self.view.addSubview(commentView)
        self.view.addSubview(commentTextField)
        self.view.addSubview(sendButton)
        
        commentView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        commentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        commentView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        commentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        commentTextField.leftAnchor.constraint(equalTo: commentView.leftAnchor, constant: 10).isActive = true
        commentTextField.centerYAnchor.constraint(equalTo: commentView.centerYAnchor).isActive = true
        commentTextField.widthAnchor.constraint(equalTo: commentView.widthAnchor, multiplier: 0.8).isActive = true
        commentTextField.heightAnchor.constraint(equalTo: commentView.heightAnchor, multiplier: 0.8).isActive = true
        
        sendButton.leftAnchor.constraint(equalTo: commentTextField.rightAnchor, constant: 4).isActive = true
        sendButton.rightAnchor.constraint(equalTo: commentView.rightAnchor, constant: -4).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: commentView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: commentTextField.heightAnchor).isActive = true
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 80)
    }
  

}

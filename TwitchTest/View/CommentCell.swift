//
//  CommentCell.swift
//  TwitchTest
//
//  Created by t19960804 on 3/2/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment?{
        didSet{
            if let authorImageURL = comment?.author?.imageURL,let authorName = comment?.author?.userName{
                userImageView.downLoadImageInCache(downLoadURL: URL(string: authorImageURL)!)
                userNameLabel.text = authorName
                if let content = comment?.comment{
                    commentTextView.text = content
                }
                
            }
        }
    }
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .yellow
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .green
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .red
        textView.isEditable = false
        return textView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        setUpConstraints()
    }
    func setUpConstraints(){
        self.addSubview(userImageView)
        self.addSubview(userNameLabel)
        self.addSubview(commentTextView)
        
        userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        userImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        userNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: 4).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
        
        commentTextView.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor).isActive = true
        commentTextView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        commentTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        commentTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

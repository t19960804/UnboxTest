//
//  FollowersTableViewCell.swift
//  TwitchTest
//
//  Created by t19960804 on 2/1/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class FollowersTableViewCell: UITableViewCell {
    
    
    var followersController: FollowersController?
    var user: User?{
        didSet{
            if let imageURl = user?.imageURL,let userName = user?.userName,let userUID = user?.uid{
                self.userImageView.downLoadImageInCache(downLoadURL: URL(string: imageURl)!)
                self.nameLabel.text = userName
                followersController?.isSubscribing(userUID: userUID, completion: { (result) in
                    if result == "本人"{
                        self.followButton.isHidden = true
                    }else if result == "已追蹤"{
                        self.followButton.setTitle(result, for: .normal)
                        self.followButton.setTitleColor(specialWhite, for: .normal)
                        self.followButton.backgroundColor = specialCyan
                    }else{
                        self.followButton.setTitle(result, for: .normal)
                        self.followButton.setTitleColor(specialCyan, for: .normal)
                        self.followButton.backgroundColor = specialWhite
                    }
                })
            }
            
        }
    }
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = specialGray2
        return label
    }()
    let followButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("追蹤", for: .normal)
        button.setTitleColor(specialWhite, for: .normal)
        button.backgroundColor = specialCyan
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(userImageView)
        self.addSubview(nameLabel)
        self.addSubview(followButton)
        setUpConstraints()
       
    }
    func setUpConstraints(){
        
        userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 5).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor,constant: 8).isActive = true
        
        followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        followButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -9).isActive = true
        followButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        followButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

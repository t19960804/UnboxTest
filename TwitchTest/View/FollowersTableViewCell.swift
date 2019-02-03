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

protocol FollowersTableViewCell_Delegate {
    func isSubscribing(userUID: String,completion: @escaping (String) -> Void)
}


class FollowersTableViewCell: UITableViewCell {
    
    var delegate: FollowersTableViewCell_Delegate?
    //
    let ref = Database.database().reference()
    let userUID = Auth.auth().currentUser?.uid
    var user: User?{
        didSet{
            if let imageURl = user?.imageURL,let userName = user?.userName,let userUID = user?.uid{
                self.userImageView.downLoadImageInCache(downLoadURL: URL(string: imageURl)!)
                self.nameLabel.text = userName
                delegate?.isSubscribing(userUID: userUID, completion: { (result) in
                    if result == "本人"{
                        self.followButton.isHidden = true
                    }else if result == "已追蹤"{
                        self.setUpFollowButton(title: result, titleColor: specialWhite, backgroundColor: specialCyan)
                    }else{
                        self.setUpFollowButton(title: result, titleColor: specialCyan, backgroundColor: specialWhite)

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
    lazy var followButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("追蹤", for: .normal)
        button.setTitleColor(specialCyan, for: .normal)
        button.backgroundColor = specialWhite
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(userImageView)
        self.addSubview(nameLabel)
        self.addSubview(followButton)
        self.selectionStyle = .none
        setUpConstraints()
    }
    func setUpFollowButton(title: String,titleColor: UIColor,backgroundColor: UIColor){
        self.followButton.setTitle(title, for: .normal)
        self.followButton.setTitleColor(titleColor, for: .normal)
        self.followButton.backgroundColor = backgroundColor
    }
    @objc func handleFollow(){
        guard let userUID = user?.uid else{return}
        let isFollowing = followButton.titleLabel?.text == "已追蹤"
        let title = isFollowing ? "追蹤" : "已追蹤"
        let titleColor = isFollowing ? specialCyan : specialWhite
        
        followButton.backgroundColor = isFollowing ? specialWhite :specialCyan
        followButton.setTitle(title, for: .normal)
        followButton.setTitleColor(titleColor, for: .normal)
        
        if isFollowing{
            deleteFollowers(followerUID: userUID)
        }else{
            addFollowers(uid: userUID)
        }

    }
    func addFollowers(uid: String){
        let userRef = ref.child("使用者").child(userUID!)
        //找尋當前使用者的追蹤名單
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            //第一次因為沒有followers節點會導致無法轉型,新增追蹤者時手用陣列包住
            if var follwersArray = dictionary["followers"] as? [String]{
                follwersArray.append(uid)
                self.updateFollowers(value: follwersArray)
            }else{
                self.updateFollowers(value: [uid])
            }
            
        }
    }
    private func updateFollowers(value: [String]){
        let userRef = ref.child("使用者").child(userUID!)
        userRef.updateChildValues(["followers" : value]) { (error, ref) in
            if let error = error{
                print("error:",error)
                return
            }
        }
    }
    func deleteFollowers(followerUID: String){
        let userRef = ref.child("使用者").child(userUID!)
        //找尋當前使用者的追蹤名單
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            if let follwersArray = dictionary["followers"] as? [String]{
                let newFollowersArray = follwersArray.filter({ (uid) -> Bool in
                    return uid != followerUID
                })
                self.updateFollowers(value: newFollowersArray)
            }
        }
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

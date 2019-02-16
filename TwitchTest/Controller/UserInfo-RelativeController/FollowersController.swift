//
//  FollowersController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/31/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class FollowersController: UITableViewController {
    let cellID = "Cell"
    var followersArray = [User]()
    var timer: Timer?
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "尚無追蹤!"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = specialGray2
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(FollowersTableViewCell.self, forCellReuseIdentifier: cellID)
        setUpNavBar()
        self.view.addSubview(messageLabel)
        setUpConstraints()
        messageLabel.isHidden = followersArray.isEmpty ? false : true
        self.tableView.separatorStyle = followersArray.isEmpty ? .none : .singleLine
    }
    func setUpNavBar(){
        self.navigationItem.title = "追蹤名單"
    }
    func setUpConstraints(){
        messageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    //MARK: - Selector方法
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FollowersTableViewCell
        let followers = followersArray[indexPath.row]
        cell.delegate = self
        cell.user = followers
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfoController = UserInfoController()
        userInfoController.user = followersArray[indexPath.row]
        self.navigationController?.pushViewController(userInfoController, animated: true)
    }
    
}
extension FollowersController: FollowersTableViewCell_Delegate{
    func isSubscribing(followingUID: String, completion: @escaping (String) -> Void) {
        let ref = Database.database().reference()
        guard let currentUserUID = Auth.auth().currentUser?.uid else{return}
        if currentUserUID == followingUID{
            completion("本人")
            return
        }
        //找出自己的追蹤者名單
        //跟目前文章的作者底下的追蹤者做比較
        //會產生三種情況,本人 / 已追蹤 / 未追蹤
        ref.child("使用者").child(currentUserUID).observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            if let following = dictionary["following"] as? [String]{
                //比對到了就return,不然會繼續比較
                //若持續沒比對到,就不要return,讓它繼續比
                for follower in following{
                    if follower == followingUID{
                        completion("已追蹤")
                        return
                    }else{
                        completion("追蹤")
                    }
                }
            }
        }
    }
    

}

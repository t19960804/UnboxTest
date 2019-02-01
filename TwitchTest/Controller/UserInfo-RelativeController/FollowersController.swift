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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(FollowersTableViewCell.self, forCellReuseIdentifier: cellID)
        setUpNavBar()

    }
    func setUpNavBar(){
        self.navigationItem.title = "追蹤名單"
    }
    private func attemptReloadTableView(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    func isSubscribing(userUID: String,completion: @escaping (String) -> Void){
        let ref = Database.database().reference()
        guard let currentUserUID = Auth.auth().currentUser?.uid else{return}
        //找出自己的追蹤者名單
        //跟目前文章的作者底下的追蹤者做比較
        //會產生三種情況,本人 / 已追蹤 / 未追蹤
        ref.child("使用者").child(currentUserUID).observe(.value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            if let followers = dictionary["followers"] as? [String]{
                for follower in followers{
                    print("follower:",follower)
                    print("userUID:",userUID)
                        if follower == userUID{
                            completion("已追蹤")
                        }else if currentUserUID == userUID{
                            completion("本人")
                        }else{
                            completion("追蹤")
                        }
                    self.attemptReloadTableView()
                }
            }
        }
    }
    //MARK: - Selector方法
    @objc func handleReloadTable(){
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
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
        cell.followersController = self
        cell.user = followers
        
        
        return cell
    }
    
}
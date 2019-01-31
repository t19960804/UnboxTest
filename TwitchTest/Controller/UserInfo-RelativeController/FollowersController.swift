//
//  FollowersController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/31/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class FollowersController: UITableViewController {
    let cellID = "Cell"
    var followersArray: [User]?{
        didSet{
            print(followersArray?.count)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setUpNavBar()
    }
    func setUpNavBar(){
        self.navigationItem.title = "追蹤名單"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
}

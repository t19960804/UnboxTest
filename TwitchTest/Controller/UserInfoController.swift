//
//  UserInfoController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/23/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class UserInfoController: UIViewController {
    
    let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "beach")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 0.4)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "個人資料"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(backImageView)
        self.view.addSubview(backView)
        setUpConstraints()
    }
    func setUpConstraints(){
        
        backImageView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: safeAreaHeight_Top).isActive = true
        backImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        backImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        backImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        
        
        backView.topAnchor.constraint(equalTo: backImageView.topAnchor).isActive = true
        backView.leftAnchor.constraint(equalTo: backImageView.leftAnchor).isActive = true
        backView.rightAnchor.constraint(equalTo: backImageView.rightAnchor).isActive = true
        backView.heightAnchor.constraint(equalTo: backImageView.heightAnchor).isActive = true
    }


}

//
//  LoginCell.swift
//  TwitchTest
//
//  Created by t19960804 on 2/17/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit

class LoginCell: UITableViewCell {
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.themePink
        textField.backgroundColor = UIColor.specialWhite
        return textField
    }()
    let bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.themePink
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(inputTextField)
        self.addSubview(bottomLine)
        inputTextField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        inputTextField.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomLine.topAnchor.constraint(equalTo: inputTextField.bottomAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

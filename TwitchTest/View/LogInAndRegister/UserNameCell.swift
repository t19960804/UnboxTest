//
//  UserNameCell.swift
//  TwitchTest
//
//  Created by t19960804 on 3/19/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
class UserNameCell: GeneralCell {

    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .themePink
        textField.backgroundColor = .specialWhite
        textField.placeholder = "輸入暱稱..."
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [.foregroundColor : UIColor.themePink])
        return textField
    }()
    let bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.themePink
        return view
    }()
    override func setUpConstarints() {
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
    
}


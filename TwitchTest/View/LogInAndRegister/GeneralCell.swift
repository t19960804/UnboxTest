//
//  GeneralCell.swift
//  TwitchTest
//
//  Created by t19960804 on 3/19/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class GeneralCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstarints()
    }
    func setUpConstarints() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

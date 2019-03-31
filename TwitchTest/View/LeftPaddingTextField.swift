//
//  LeftPaddingTextField.swift
//  TwitchTest
//
//  Created by t19960804 on 3/26/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class LeftPaddingTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5, dy: 0)
    }
}

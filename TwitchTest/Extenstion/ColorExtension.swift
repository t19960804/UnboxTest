//
//  ColorExtension.swift
//  TwitchTest
//
//  Created by t19960804 on 2/16/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    static func setRGB(red: CGFloat,green: CGFloat,blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    static var themePink: UIColor{
        return UIColor.setRGB(red: 252, green: 81, blue: 133)
    }
    static var darkHeartColor: UIColor{
        return UIColor.setRGB(red: 233, green: 47, blue: 96)
    }
    static var specialWhite: UIColor{
        return UIColor.setRGB(red: 245, green: 245, blue: 245)
    }
    static var specialCyan: UIColor{
        return UIColor.setRGB(red: 63, green: 193, blue: 201)
    }
    static var specialGray: UIColor{
        return UIColor.setRGB(red: 228, green: 231, blue: 233)
    }
    static var specialGray2: UIColor{
        return UIColor.setRGB(red: 52, green: 52, blue: 52)
    }
    static var shadowGray: UIColor{
        return UIColor.setRGB(red: 120, green: 121, blue: 122)
    }
    static var gradient_Pink: UIColor{
        return UIColor(red: 237/255, green: 110/255, blue: 160/255, alpha: 1)
    }
    static var gradient_Orange: UIColor{
        return UIColor(red: 236/255, green: 140/255, blue: 105/255, alpha: 1)
    }
}


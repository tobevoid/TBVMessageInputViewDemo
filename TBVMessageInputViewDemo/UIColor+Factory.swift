//
//  UIColor+Factory.swift
//  TBVInputViewDemo
//
//  Created by tripleCC on 16/8/9.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    convenience init(hex: Int, alpha: CGFloat) {
        let red = CGFloat(((hex & 0xFF0000) >> 16)) / 255.0
        let green = CGFloat(((hex & 0xFF00) >> 8)) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


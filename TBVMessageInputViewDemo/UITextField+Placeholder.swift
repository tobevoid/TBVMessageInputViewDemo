//
//  UITextView+Placeholder.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

public extension UITextField {
    struct PlaceholderColorToken {
        static var onceToken: dispatch_once_t = 0
    }
    
    public var placeholderColor: UIColor {
        placeholder = "0"
        return valueForKeyPath("_placeholderLabel.textColor") as? UIColor ?? UIColor()
    }

    static var placeholderColor: UIColor {
        var placeholderColor: UIColor = UIColor()
        dispatch_once(&PlaceholderColorToken.onceToken) {
            placeholderColor = UITextField().placeholderColor
        }
        return placeholderColor
    }
}
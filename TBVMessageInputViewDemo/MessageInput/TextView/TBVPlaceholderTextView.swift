//
//  TBVPlaceholderTextView.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

private let kTBVPlaceholderLabelX = CGFloat(4.0)
private let kTBVPlaceholderLabelY = CGFloat(7.0)

public class TBVPlaceholderTextView: UITextView {
    // MARK:  view factory
    lazy private var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 0
        placeholderLabel.textColor = UITextField.placeholderColor
        placeholderLabel.textAlignment = .Left
        placeholderLabel.font = self.font
        return placeholderLabel
    }()
    private var textCache: String?
    // MARK:  life cycle
    public init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        font = UIFont.systemFontOfSize(14.0)
        alwaysBounceVertical = true
        addSubview(placeholderLabel)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textViewTextDidChange), name: UITextViewTextDidChangeNotification, object: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.frame.origin.x = kTBVPlaceholderLabelX
        placeholderLabel.frame.origin.y = kTBVPlaceholderLabelY
        placeholderLabel.frame.size.width = bounds.size.width - kTBVPlaceholderLabelX
    }
    
    // MARK:  text action
    public func clearText() {
        text = ""
    }
    
    public func cacheText() {
        textCache = text
    }
    
    public func fetchTextCache() -> String {
        return textCache ?? ""
    }
    
    public func setTextByTextCache() {
        text = textCache ?? ""
    }
}

// MARK: - notification response
extension TBVPlaceholderTextView {
    func textViewTextDidChange() {
        placeholderLabel.hidden = hasText()
    }
}

// MARK: - getter setter
extension TBVPlaceholderTextView {
    public var placeholderColor: UIColor {
        get {
            return placeholderLabel.textColor
        }
        set {
            placeholderLabel.textColor = newValue
        }
    }
    
    public var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
            placeholderLabel.sizeToFit()
            layoutIfNeeded()
        }
    }
    
    public var placeholderFont: UIFont {
        get {
            return placeholderLabel.font
        }
        set {
            placeholderLabel.font = newValue
            layoutIfNeeded()
        }
    }
    
    public override var attributedText: NSAttributedString! {
        get {
            return super.attributedText
        }
        set {
            super.attributedText = newValue
            placeholderLabel.hidden = hasText()
        }
    }
    
    public override var text: String! {
        get {
            return super.text
        }
        set {
            super.text = newValue
            placeholderLabel.hidden = hasText()
        }
    }
}

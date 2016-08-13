//
//  TBVMessageInputViewProtocol.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/3.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

public protocol TBVMessageInputViewProtocol {
    var inputCoreView: TBVMessageInputCoreView {get set}
    var text: String {get set}
    init()
}

extension TBVMessageInputViewProtocol where Self: UIView {
    init() {
        self.init(frame: .zero)
    }
    public var text: String {
        get {
            return inputCoreView.textView.text
        }
        set {
            inputCoreView.textView.text = text
        }
    }
}
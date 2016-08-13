//
//  TBVMessageInputView.swift
//  TBVInputViewDemo
//
//  Created by tripleCC on 16/8/10.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

public class TBVMessageInputView: UIView {
    private lazy var topLineView: UIView = {
        let topLineView = UIView()
        topLineView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        return topLineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        addSubview(topLineView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func layoutPageSubviews() {
        topLineView.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        bringSubviewToFront(topLineView)
    }
}

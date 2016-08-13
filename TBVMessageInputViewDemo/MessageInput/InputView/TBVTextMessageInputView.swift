//
//  TBVMessageInputCoreView.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

public class TBVTextMessageInputView: TBVMessageInputView, TBVMessageInputViewProtocol {
    lazy public var inputCoreView: TBVMessageInputCoreView = {
        let inputCoreView = TBVMessageInputCoreView(host: self)
        return inputCoreView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(inputCoreView)
        layoutPageSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func layoutPageSubviews() {
        super.layoutPageSubviews()
        inputCoreView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}
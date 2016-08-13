//
//  TBVMessageAudioCancelView.swift
//  TBVInputViewDemo
//
//  Created by tripleCC on 16/8/9.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

class TBVMessageAudioCancelView: UIView {
    private lazy var cancelTipLabel: TBVMessageAudioTipLabel = {
        let cancelTipLabel = TBVMessageAudioTipLabel(text: "松开手指，取消发送")
        cancelTipLabel.backgroundColor = UIColor(hex: 0x7D0022)
        return cancelTipLabel
    }()
    
    private lazy var cancelImageView: UIImageView = {
        let cancelImageView = UIImageView(image: UIImage(named: "message_input_cancel_back"))
        cancelImageView.contentMode = .ScaleAspectFit
        return cancelImageView
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(cancelImageView)
        addSubview(cancelTipLabel)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutPageSubviews() {
        cancelTipLabel.sizeToFit()
        cancelTipLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-15.0)
            make.width.equalTo(140.0)
            make.height.equalTo(30.0)
        }
        
        debugPrint(cancelTipLabel.frame.size)
        
        cancelImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(34.0)
            make.width.equalTo(55.0)
            make.height.equalTo(60.0)
        }
    }
}

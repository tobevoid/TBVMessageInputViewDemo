//
//  TBVMessageAudioWarningView.swift
//  TBVInputViewDemo
//
//  Created by tripleCC on 16/8/9.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

class TBVMessageAudioWarningView: UIView {
    var warningString: String? {
        didSet {
            waringLabel.text = warningString
            waringLabel.sizeToFit()
            layoutIfNeeded()
        }
    }
    
    private lazy var warningImageView: UIImageView = {
        let warningImageView = UIImageView(image: UIImage(named: "message_input_warning"))
        warningImageView.contentMode = .ScaleAspectFit
        return warningImageView
    }()
    
    private var waringLabel = TBVMessageAudioTipLabel()
    init() {
        super.init(frame: .zero)
        addSubview(warningImageView)
        addSubview(waringLabel)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutPageSubviews() {
        warningImageView.snp_makeConstraints { (make) in
            make.width.equalTo(15.0)
            make.height.equalTo(66.0)
            make.top.equalTo(37.0)
            make.centerX.equalTo(self)
        }
        waringLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-15.0)
            make.centerX.equalTo(self)
        }
    }
}

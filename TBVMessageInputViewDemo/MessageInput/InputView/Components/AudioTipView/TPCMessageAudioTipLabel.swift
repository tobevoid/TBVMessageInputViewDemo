//
//  TBVMessageAudioTipLabel.swift
//  TBVInputViewDemo
//
//  Created by tripleCC on 16/8/9.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

class TBVMessageAudioTipLabel: UILabel {

    init(text: String? = nil) {
        super.init(frame: .zero)
        self.text = text
        font = UIFont.systemFontOfSize(14.0)
        textColor = UIColor.whiteColor()
        textAlignment = .Center
        layer.cornerRadius = 5.0
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

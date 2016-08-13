//
//  TBVMessageAudioVolumeLevelView.swift
//  TBVInputViewDemo
//
//  Created by tripleCC on 16/8/9.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

class TBVMessageAudioVolumeLevelView: UIView {
    private lazy var levelImageViews: [UIImageView] = {
        var levelImageViews = [UIImageView]()
        for i in 0..<6 {
            let imageName = "message_input_volume_\(i + 1)"
            let levelImageView = UIImageView(image: UIImage(named: imageName))
            levelImageView.hidden = i != 0
            levelImageViews.append(levelImageView)
        }
        return levelImageViews
    }()
    
    private lazy var microphoneImageView: UIImageView = {
        let microphoneImageView = UIImageView(image: UIImage(named: "message_input_recording_microphone"))
        microphoneImageView.contentMode = .ScaleAspectFit
        return microphoneImageView
    }()
    
    private var cancelTipLabel = TBVMessageAudioTipLabel(text: "松开发送，上滑取消")
    
    var volumeLevel: Float = 0 {
        willSet {
            guard volumeLevel != newValue else { return }
            levelImageViews.enumerate().forEach { imageView in
                /* 音量很难达到1，所以这里增大1.5倍 */
                imageView.element.hidden = Float(imageView.index) > newValue * Float(levelImageViews.count) * 1.5
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        levelImageViews.forEach{ self.addSubview($0) }
        addSubview(microphoneImageView)
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
        }
        
        microphoneImageView.snp_makeConstraints { (make) in
            make.left.equalTo(45.0)
            make.top.equalTo(36.0)
            make.width.equalTo(44.0)
            make.height.equalTo(68.0)
        }
        
        var lastImageView: UIView? = nil
        for imageView in levelImageViews {
            imageView.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(microphoneImageView.snp_right).offset(10.0)
                make.width.equalTo(26.0)
                make.height.equalTo(10.0)
                if let lastImageView = lastImageView {
                    make.bottom.equalTo(lastImageView.snp_top).offset(-2.0)
                } else {
                    make.bottom.equalTo(microphoneImageView.snp_bottom)
                }
            })
            lastImageView = imageView
        }

    }
}

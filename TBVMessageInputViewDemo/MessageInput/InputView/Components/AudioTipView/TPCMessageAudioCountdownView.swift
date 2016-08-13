//
//  TBVMessageAudioCountdownView.swift
//  TBVInputViewDemo
//
//  Created by tripleCC on 16/8/9.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

class TBVMessageAudioCountdownView: UIView {
    private lazy var countdownLabel: UILabel = {
        let countdownLabel = UILabel()
        countdownLabel.font = UIFont.systemFontOfSize(99)
        countdownLabel.textColor = UIColor.whiteColor()
        return countdownLabel
    }()
    
    private var countdownTimer: NSTimer?
    private var countdownDuration: NSTimeInterval = 0
    private var cancelTipLabel = TBVMessageAudioTipLabel(text: "松开发送，上滑取消")
    var countdowning: Bool {
        return countdownTimer?.valid ?? false
    }
    init() {
        super.init(frame: .zero)
        addSubview(countdownLabel)
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
        countdownLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(0)
        }
    }
    
    func startCountdownWithDuration(duration: NSTimeInterval) {
        countdownDuration = duration
        
        countdownTimer?.invalidate()
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(countdownTimerTriggered), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(countdownTimer!, forMode: NSRunLoopCommonModes)
        countdownTimerTriggered()
    }
    
    func stopCountdown() {
        countdownTimer?.invalidate()
        countdownLabel.text = ""
    }
    
    func countdownTimerTriggered() {
        if countdownDuration <= 0 {
            countdownTimer?.invalidate()
        } else {
            countdownLabel.text = "\(Int(countdownDuration))"
            countdownLabel.sizeToFit()
            layoutIfNeeded()
        }
        countdownDuration -= 1.0
    }
}

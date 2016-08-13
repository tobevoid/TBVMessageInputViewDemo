//
//  TBVMessageAudioTipManager.swift
//  TBVInputViewDemo
//
//  Created by tripleCC on 16/8/9.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

class TBVMessageAudioTipView: UIView {
    private var warningView = TBVMessageAudioWarningView()
    private var volumeLevelView = TBVMessageAudioVolumeLevelView()
    private var countdownView = TBVMessageAudioCountdownView()
    private var cancelView = TBVMessageAudioCancelView()
    private var recorderStatus: TBVMessageAudioRecordStatus = .Started
    
    init() {
        super.init(frame: .zero)
        addSubview(warningView)
        addSubview(volumeLevelView)
        addSubview(countdownView)
        addSubview(cancelView)
        layoutPageSubviews()
        
        backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        layer.cornerRadius = 10.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutPageSubviews() {
        warningView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        volumeLevelView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        countdownView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        cancelView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func startCountdownWithDuration(duration: NSTimeInterval) {
        if !countdownView.hidden && !countdownView.countdowning {
            countdownView.startCountdownWithDuration(duration)
        }
    }
    func stopCountdown() {
        countdownView.stopCountdown()
    }
    
    func showTipWithRecordStatus(recorderStatus: TBVMessageAudioRecordStatus,
                                 volumeLevel: Float = 0) {
        hidden = false
        switch recorderStatus {
        case .Over1M:
            warningView.warningString   = "超出录音时限"
        case .TooShortEnded:
            warningView.warningString   = "录音时间太短"
        case .Started:
            fallthrough
        case .Recording:
            volumeLevelView.volumeLevel = volumeLevel
        case .NormalEnded:
            return
        default:
            break
        }
        
        warningView.hidden      = recorderStatus != .Over1M &&
            recorderStatus != .TooShortEnded
        volumeLevelView.hidden  = recorderStatus != .Started &&
            recorderStatus != .Recording
        countdownView.hidden    = recorderStatus != .Left5S
        cancelView.hidden       = recorderStatus != .Cancelled
        self.recorderStatus     = recorderStatus
    }
    
    func hide() {
        hidden = true
        stopCountdown()
    }
}
//
//  TBVAudioMessageInputView.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/1.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit

enum TBVAudioMessagePressButtonType: String {
    case Talk     = "按住 说话"
    case End      = "松开 结束"
    case Answer   = "按住使用语音回复"
}

enum TBVMessageAudioRecordStatus: Int {
    /** 开始录音 */
    case Started
    /** 过短 */
    case TooShortEnded
    /** 正常录音中 */
    case Recording
    /** 剩下5s */
    case Left5S
    /** 正常结束 */
    case NormalEnded
    /** 超出一分钟 */
    case Over1M
    /** 取消 */
    case Cancelled
}

protocol TBVAudioMessageInputViewDelegate: NSObjectProtocol {
    func audioMessageInputView(inputView: TBVAudioMessageInputView, didChangeRecordStatus status: TBVMessageAudioRecordStatus)
}

private let kTBVAudioCancelCurrentRecordingThresholdDistance = CGFloat(15.0)
private let kTBVAudioRecordingCountdownDutaion  = NSTimeInterval(5.0)
private let kTBVAudioRecordingMinDutaion        = NSTimeInterval(1.0)
private let kTBVAudioRecordingMaxDutaion        = NSTimeInterval(8.0)
private let kTBVAudioPressButtonHighlightColor  = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)

public class TBVAudioMessageInputView: TBVMessageInputView, TBVMessageInputViewProtocol {
    lazy public var inputCoreView: TBVMessageInputCoreView = {
        let inputCoreView = TBVMessageInputCoreView(host: self)
        inputCoreView.dataSource = self
        return inputCoreView
    }()
    lazy var inputTypeView: TBVMessageAudioView = {
        let inputTypeView = TBVMessageAudioView()
        inputTypeView.delegate = self
        return inputTypeView
    }()
    lazy var audioRecorderManager: TBVAudioRecorderManager = {
        let audioRecorderManager = TBVAudioRecorderManager()
        audioRecorderManager.delegate = self
        return audioRecorderManager
    }()
    weak var delegate: TBVAudioMessageInputViewDelegate?
    private lazy var audioTipView: TBVMessageAudioTipView = {
        let audioTipView = TBVMessageAudioTipView()
        audioTipView.hidden = true
        return audioTipView
    }()
    
    private lazy var pressButton: UIButton = {
        let pressButton = UIButton(type: .Custom)
        pressButton.titleLabel?.textAlignment = .Center
        pressButton.titleLabel?.font   = UIFont.systemFontOfSize(16.0)
        pressButton.layer.cornerRadius = self.inputCoreView.textView.layer.cornerRadius
        pressButton.layer.borderWidth  = self.inputCoreView.textView.layer.borderWidth
        pressButton.layer.borderColor  = self.inputCoreView.textView.layer.borderColor
        pressButton.setTitleColor(UIColor.blackColor().colorWithAlphaComponent(0.6), forState: .Normal)
        pressButton.addGestureRecognizer(self.longPressGesture)
        pressButton.setTitle(TBVAudioMessagePressButtonType.Talk.rawValue, forState: .Normal)
        return pressButton
    }()
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureTriggered))
        longPressGesture.minimumPressDuration = 0
        longPressGesture.delaysTouchesBegan = true
        return longPressGesture
    }()
    private lazy var rightOccupiedView: UIView = {
        let rightOccupiedView = UIView()
        rightOccupiedView.alpha = 0
        return rightOccupiedView
    }()
    private var cancelCurrentRecording = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        addSubview(inputCoreView)
        addSubview(inputTypeView)
        addSubview(pressButton)
        addSubview(rightOccupiedView)
        UIApplication.sharedApplication().keyWindow?.addSubview(audioTipView)
        layoutPageSubviews()
        renderSubviewsByInputType(inputTypeView.inputType)
    }
    
    deinit {
        audioTipView.removeFromSuperview()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func layoutPageSubviews() {
        super.layoutPageSubviews()
        inputTypeView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 35.0, height: 35.0))
            make.left.equalTo(5.0)
            make.centerY.equalTo(self)
        }
        rightOccupiedView.snp_makeConstraints { (make) in
            make.right.height.centerY.equalTo(self)
            make.width.equalTo(inputTypeView)
        }
        inputCoreView.snp_makeConstraints { (make) in
            make.left.equalTo(inputTypeView.snp_right)
            make.right.height.top.equalTo(self)
        }
        pressButton.snp_makeConstraints { (make) in
            make.left.equalTo(inputCoreView).offset(inputCoreView.contentInset.left)
            make.top.equalTo(inputCoreView).offset(inputCoreView.contentInset.top)
            make.bottom.equalTo(inputCoreView).offset(-inputCoreView.contentInset.bottom)
            make.right.equalTo(rightOccupiedView.snp_left).offset(-5.0)
        }
        audioTipView.snp_makeConstraints { (make) in
            make.center.equalTo(UIApplication.sharedApplication().keyWindow!)
            make.size.equalTo(CGSize(width: 160.0, height: 160.0))
        }
    }
}

// MARK: - TBVMessageInputCoreViewLayoutDataSource
extension TBVAudioMessageInputView: TBVMessageInputCoreViewLayoutDataSource {
    public func coreViewActionForHeightChange(coreView: TBVMessageInputCoreView) -> (() -> Void)? {
        return {
            /* 这里不能调用self.layoutIfNeeded()，否则textView内容会抖动 */
            self.inputTypeView.layoutIfNeeded()
        }
    }
}

// MARK: - TBVMessageAudioViewDelegate
extension TBVAudioMessageInputView: TBVMessageAudioViewDelegate {
    func messageAudioView(audioView: TBVMessageAudioView, didChangeInputType inputType: TBVMessageAudioInputType) {
        if inputType == .Keyboard {
            inputCoreView.textView.setTextByTextCache()
            inputCoreView.textView.becomeFirstResponder()
        } else {
            inputCoreView.textView.cacheText()
            inputCoreView.textView.clearText()
            inputCoreView.textView.resignFirstResponder()
        }
        renderSubviewsByInputType(inputType)
    }
    
    private func renderSubviewsByInputType(inputType: TBVMessageAudioInputType) {
        let alpha = inputType == .Keyboard
        pressButton.alpha = CGFloat(!alpha)
        inputCoreView.alpha = CGFloat(alpha)
    }
}

/*
 * 录音开始->    (<1s)  ->  正常录音(界面同录音开始) -> 5s倒计时 ->   (>60s)
 * |   录音长度不足     |            正常结束                 |    超出时限    |
 */

/*
 * 0 -> kTBVAudioCancelCurrentRecordingThresholdDistance ->  infinite
 * |                  正常录音                            |    取消录音    |
 */
extension TBVAudioMessageInputView: TBVAudioRecorderManagerDelegate {
    public func audioRecorderManager(manager: TBVAudioRecorderManager, didOutputVolume volume: Float) {
        if manager.recorderDuration > kTBVAudioRecordingMaxDutaion {
            debugPrint("over max recording duration")
            /* 超出时限 */
            manager.stopRecord()
            changeRecordreStatus(.Over1M)
            resetRecorderStatusInSeconds(0.5)
            audioTipView.stopCountdown()
            refreshLongPressGeture()
        } else if manager.recorderDuration >= kTBVAudioRecordingMaxDutaion - kTBVAudioRecordingCountdownDutaion {
            /* 5s倒计时 */
            if !cancelCurrentRecording {
                debugPrint("start 5s countdown")
                changeRecordreStatus(.Left5S)
            }
            audioTipView.startCountdownWithDuration(kTBVAudioRecordingCountdownDutaion)
        } else {
            /* 正常录音 */
            if !cancelCurrentRecording {
                debugPrint("volume level \(volume)")
                changeRecordreStatus(.Recording, volumeLevel: volume)
            }
        }
    }
}
extension TBVAudioMessageInputView {
    private var recordKey: String {
        return String(format: "%.0lf", NSDate().timeIntervalSince1970)
    }
    
    @objc func longPressGestureTriggered(gesture: UILongPressGestureRecognizer) {
        let location = gesture.locationInView(superview)
        /*  上移超过'kTBVAudioCancelCurrentRecordingThresholdDistance'视为取消动作 */
        cancelCurrentRecording = location.y < frame.origin.y - kTBVAudioCancelCurrentRecordingThresholdDistance
        
        if gesture.state == .Began {
            longPressGesture.view?.backgroundColor = kTBVAudioPressButtonHighlightColor
            audioRecorderManager.startRecordWithKey(recordKey, success: {
                debugPrint("start recording")
                self.changeRecordreStatus(.Started)
                self.setPressButtonType(.End)
                }, failure: {
                    debugPrint("not allow to access recorder")
                    self.delegate?.audioMessageInputView(self, didChangeRecordStatus: .Cancelled)
                    self.resetRecorderStatusInSeconds(0)
            })
        }
        guard audioRecorderManager.recordPermissionGranted else {
            resetRecorderStatusInSeconds(0)
            return
        }
        
        if gesture.state == .Ended {
            if cancelCurrentRecording {
                debugPrint("cancel recording")
                /* 录音取消 */
                audioRecorderManager.deleteRecording()
                changeRecordreStatus(.Cancelled)
                resetRecorderStatusInSeconds(0.5)
            } else if audioRecorderManager.recorderDuration < kTBVAudioRecordingMinDutaion {
                debugPrint("recording duration is too short")
                /* 录音长度不足 */
                audioRecorderManager.deleteRecording()
                changeRecordreStatus(.TooShortEnded)
                resetRecorderStatusInSeconds(1.0)
            } else {
                debugPrint("recording is normal end")
                /* 正常结束 */
                audioRecorderManager.stopRecord()
                changeRecordreStatus(.NormalEnded)
                resetRecorderStatusInSeconds(0.5)
            }
            return
        } else if gesture.state == .Cancelled {
            debugPrint("cancel gesture")
            /* 取消手势，'refreshLongPressGeture'后会调用 */
        }
        
        if cancelCurrentRecording {
            audioTipView.showTipWithRecordStatus(.Cancelled)
        } else if audioRecorderManager.recorderDuration < kTBVAudioRecordingMaxDutaion - kTBVAudioRecordingCountdownDutaion {
            audioTipView.showTipWithRecordStatus(.Started)
        }
    }
    
    private func changeRecordreStatus(status: TBVMessageAudioRecordStatus,
                                      volumeLevel: Float = 0) {
        audioTipView.showTipWithRecordStatus(status, volumeLevel: volumeLevel)
        delegate?.audioMessageInputView(self, didChangeRecordStatus: status)
    }
    
    private func resetRecorderStatusInSeconds(seconds: NSTimeInterval) {
        pressButton.backgroundColor = UIColor.whiteColor()
        setPressButtonType(.Talk)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSTimeInterval(NSEC_PER_SEC) * seconds)), dispatch_get_main_queue(), {
            self.audioRecorderManager.stopAudioRecorderTimer()
            self.audioTipView.hide()
        })
    }
    
    /* 强制结束旧手势 */
    private func refreshLongPressGeture() {
        longPressGesture.enabled = false
        longPressGesture.enabled = true
    }
}

// MARK: - public methods
extension TBVAudioMessageInputView {
    func setPressButtonType(type: TBVAudioMessagePressButtonType) {
        pressButton.setTitle(type.rawValue, forState: .Normal)
    }
}
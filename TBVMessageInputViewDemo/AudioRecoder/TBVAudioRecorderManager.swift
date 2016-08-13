//
//  TBVAudioRecorderManager.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/6.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import UIKit
import AVFoundation

public protocol TBVAudioRecorderManagerDelegate: NSObjectProtocol {
    func audioRecorderManager(manager: TBVAudioRecorderManager, didOutputVolume volume: Float)
}

public class TBVAudioRecorderManager {
    private lazy var audioSession: AVAudioSession = {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
        } catch let error {
            debugPrint("fail to set category with error: \(error)")
        }
        return audioSession
    }()
    private var recordSetting: [String : AnyObject] {
        var recordSetting = [String : AnyObject]()
        recordSetting[AVFormatIDKey] = NSNumber(unsignedInt: formatID)
        recordSetting[AVSampleRateKey] = NSNumber(float: sampleRate)
        recordSetting[AVNumberOfChannelsKey] = NSNumber(integer: numberOfChannels)
        recordSetting[AVEncoderAudioQualityKey] = NSNumber(integer: encoderAudioQuality.rawValue)
        recordSetting[AVSampleRateConverterAudioQualityKey] = NSNumber(integer: sampleRateConverterAudioQuality.rawValue)
        recordSetting[AVLinearPCMBitDepthKey] = NSNumber(integer: linearPCMBitDepth)
        return recordSetting
    }
    private var audioRecorder: AVAudioRecorder!
    private var audioRecorderTimer: NSTimer?
    
    // MARK:  record setting
    public var formatID = kAudioFormatMPEG4AAC
    public var sampleRate = Float(11025)
    public var numberOfChannels = Int(1)
    public var encoderAudioQuality: AVAudioQuality = .Medium
    public var sampleRateConverterAudioQuality: AVAudioQuality = .Medium
    public var linearPCMBitDepth = Int(16)
    public var recordPermissionGranted: Bool = false
    
    public var volumeOutputTimeInterval = NSTimeInterval(0.2)
    weak public var audioRecorderDelegate: AVAudioRecorderDelegate?
    weak public var delegate: TBVAudioRecorderManagerDelegate?
    public var failHandler: TBVAudioRecorderFailHandlerProtocol?
    public var cacheManager = TBVAudioRecorderCacheManager()
    
    private var validRecorderDuration: NSTimeInterval = 0
    public var recorderDuration: NSTimeInterval {
        return audioRecorder.recording ? audioRecorder.currentTime : validRecorderDuration
    }
    
    public var recorderURL: NSURL {
        return audioRecorder.url
    }
}

extension TBVAudioRecorderManager {
    public func requestRecordPermissionWithCompletion(completion: (Bool) -> Void) {
        audioSession.requestRecordPermission { (granted) in
            if !granted {
                self.failHandler?.forbidToAccessRecorderHandler()
                completion(granted)
            }
        }
    }
    
    public func startRecordWithKey(key: String, success: () -> Void, failure: () -> Void) {
        guard let URL = NSURL(string: cacheManager.cachePathForKey(key)) else { return }
        startRecordWithURL(URL, success: success, failure: failure)
    }
    public func startRecordWithURL(URL: NSURL, success: () -> Void, failure: () -> Void) {
        audioSession.requestRecordPermission { (granted) in
            self.recordPermissionGranted = granted
            guard granted else {
                self.failHandler?.forbidToAccessRecorderHandler()
                return
            }
            do {
                self.audioRecorder = try AVAudioRecorder(URL: URL, settings: self.recordSetting)
                self.audioRecorder.meteringEnabled = true
                self.audioRecorder.delegate = self.audioRecorderDelegate
                guard self.audioRecorder.prepareToRecord() &&
                    self.audioRecorder.record() else {
                        self.failHandler?.failToRecodHandler()
                        failure()
                        debugPrint("fail to record")
                        return
                }
                self.startAudioRecorderTimer()
                success()
            } catch let error {
                debugPrint("fail to create audio recorder with error:\(error)")
            }
        }
    }
    public func stopRecord() {
        stopAudioRecorderTimer()
        audioRecorder.stop()
    }
    
    public func pauseRecord() {
        audioRecorder.pause()
    }
    
    public func deleteRecording() {
        stopRecord()
        if !audioRecorder.deleteRecording() {
            debugPrint("fail to delete recording")
        }
    }
}

extension TBVAudioRecorderManager {
    func startAudioRecorderTimer() {
        audioRecorderTimer?.invalidate()
        audioRecorderTimer = NSTimer(timeInterval: volumeOutputTimeInterval, target: self, selector: #selector(audioRecorderTimerDidTriggered), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(audioRecorderTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func stopAudioRecorderTimer() {
        audioRecorderTimer?.invalidate()
    }
    
    @objc func audioRecorderTimerDidTriggered(timer: NSTimer) {
        if audioRecorder.recording {
            /* 保留当前录音时长，'currentTime'会在录音停止时变为0 */
            validRecorderDuration = audioRecorder.currentTime
        }
        delegate?.audioRecorderManager(self, didOutputVolume: audioRecorder.volumeLevelOfChannel(0))
    }
}

//
//  AVAudioRecorder+VolumeLevel.swift
//  TBVInputViewDemo
//
//  Created by tripleCC on 16/8/8.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import AVFoundation

extension AVAudioRecorder {
    /**
     返回当前录音量级
     
     - parameter channel: 通道
     
     - returns: (0~1)量级
     */
    public func volumeLevelOfChannel(channel: Int) -> Float {
        updateMeters()
        var level = Float(0)
        let minDecibes = Float(-80.0)
        let decibels = averagePowerForChannel(channel)
        if decibels < minDecibes {
            level = 0
        } else if decibels >= 0 {
            level = 1.0
        } else {
            let root = Float(2.0)
            let minAmp = powf(10.0, 0.05 * minDecibes)
            let inverseAmpRange = 1.0 / (1.0 - minAmp)
            let amp = powf(10.0, 0.05 * decibels)
            let adjAmp = (amp - minAmp) * inverseAmpRange
            level = powf(adjAmp, 1.0 / root)
        }
        return level
    }
}


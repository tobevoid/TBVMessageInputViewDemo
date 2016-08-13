//
//  TBVAudioRecorderFailHandlerProtocol.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/6.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import Foundation

public protocol TBVAudioRecorderFailHandlerProtocol {
    func forbidToAccessRecorderHandler()
    func failToRecodHandler()
}
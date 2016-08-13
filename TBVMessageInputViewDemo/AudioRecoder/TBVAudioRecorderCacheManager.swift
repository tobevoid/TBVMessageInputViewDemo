//
//  TBVAudioRecorderCache.swift
//  TBVMessageInputVIewDemo
//
//  Created by tripleCC on 16/8/6.
//  Copyright © 2016年 tripleCC. All rights reserved.
//

import Foundation

public class TBVAudioRecorderCacheManager {
    lazy var diskCachePath: String = {
        let path: NSString = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!
        return path.stringByAppendingPathComponent("com.triplecc.TBVAudioRecorderCache")
    }()
    
    
    init() {
        if !NSFileManager.defaultManager().fileExistsAtPath(diskCachePath) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(diskCachePath, withIntermediateDirectories: false, attributes: nil)
            } catch let error {
                debugPrint("fail to create directory at path \(diskCachePath) with error: \(error)")
            }
        }
    }
    public func cachePathForKey(key: String) -> String {
        return (diskCachePath as NSString).stringByAppendingPathComponent(key)
    }
    
    public func removeRecordForKey(key: String) {
        removeFileForPath(cachePathForKey(key))
    }
    
    public func removeAllRecords() {
        removeFileForPath(diskCachePath)
    }
    
    private func removeFileForPath(path: String) {
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch let error {
                debugPrint("fail to remove item at path \(path) with error: \(error)")
            }
        }
    }
}